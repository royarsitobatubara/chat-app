import { Server, Socket } from "socket.io";
import userService from "../services/user-service.js";
import contactService from "../services/contact-service.js";
import logger from "../helpers/app-logger.js";
import contactModel from "../models/contact-model.js";
import messageModel from "../models/message-model.js";
import AppResponse from "../helpers/app-response.js";

const onlineUsers = new Map();

/**
 * CONTACT SOCKET
 * @param {Server} io 
 * @param {Socket} socket 
 * @param {Map} userOnline 
 */
async function messageSocket(io, socket, userOnline) {

    socket.on("message:send_message", async (data) => {
        const {id, emailSender, emailReceiver, message, status, type, time} = data;

        socket.emit("message:status_update", AppResponse.messageStatus(id, status="sent"));

        try {
            // Kirim jika penerima online
            if (userOnline.has(emailReceiver)) {
                io.to(emailReceiver).emit("message:receive_message", AppResponse.message(
                    id, message, emailSender, emailReceiver, type, status="delivered", time 
                ));
                // Kirim feedback ke pengirim
                socket.emit("message:status_update", AppResponse.messageStatus(id, status="delivered"));
            } else {
                // Jika offline masukan database
                await messageModel.insert({
                    id,
                    emailSender,
                    emailReceiver,
                    message,
                    type,
                    status: "sent",
                    time
                });
            }

        } catch (error) {
            logger.error(`Socket message:send_message error: ${error}`);
            socket.emit("error", { message: 'Failed send message' });
        }
    });

    socket.on("message:typing", (data) => {
        const {emailSender, emailReceiver, isTyping} = data;
        io.to(emailReceiver).emit("typing", {
            emailSender,
            isTyping
        });
    });

    
}

export default messageSocket;