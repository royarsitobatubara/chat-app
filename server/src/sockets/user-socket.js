import { Server, Socket } from "socket.io";
import userService from "../services/user-service.js";
import contactService from "../services/contact-service.js";
import logger from "../helpers/app-logger.js";
import contactModel from "../models/contact-model.js";
import messageModel from "../models/message-model.js";

const onlineUsers = new Map();

/**
 * CONTACT SOCKET
 * @param {Server} io 
 * @param {Socket} socket 
 * @param {Map} userOnline 
 */
async function userSocket(io, socket, userOnline) {

    /**
     * UPDATE USERNAME
     */
    socket.on("user:update_username", async(data)=> {
        const {email, newUsername} = data;
        try {
            await userService.updateUsername({email, username: newUsername});
            const contacts = await contactService.getContactByReceiver({receiver: email});

            contacts.forEach(contact => {
                const ownerEmail = contact.emailSender;
                io.to(ownerEmail).emit("user:updated_username", {
                    email,
                    newUsername
                });
            });

            logger.info(`${email} update username: ${newUsername}`);
        } catch (error) {
            logger.error(`Socket user:update:username error: ${error}`);
            socket.emit("error", {message: 'Failed update username'});
        }
    });

    socket.on("user:online", async(email)=> {
        // jika online masukan ke userOnline
        userOnline.set(email, socket.id);
        // lalu join
        socket.join(email);
        logger.info(`${email} is online`);
        // cari messages di database yang belum terkirim ke penerima
        const sentMessages = await messageModel.findSentMessages(email);
        // Kirim ke penerima jika online
        for(const itm of sentMessages) {
            io.to(email).emit('message:receive_message', {
                id: itm.id,
                message: itm.message,
                emailSender: itm.emailSender,
                emailReceiver: itm.emailReceiver,
                type: itm.type,
                status: "delivered",
                time: itm.time
            });

            const senderEmail = itm.emailSender;
            if (userOnline.has(senderEmail)) {
                io.to(senderEmail).emit("message:status_update", {
                    id: itm.id,
                    status: "delivered"
                });
                // hapus pesan di database
                await messageModel.deleteMessage(itm.id);
            }
        };
    });

}

export default userSocket;
