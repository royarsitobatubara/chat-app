import { Server, Socket } from "socket.io";
import logger from "../helpers/app-logger.js";
const onlineUsers = new Map();

/**
 * CONTACT SOCKET
 * @param {Server} io 
 * @param {Socket} socket 
 * @param {Map} userOnline 
 */
async function userSocket(io, socket, userOnline) {
    socket.on('user-register', (email)=> {
        if(!email)return;
        userOnline.set(email, socket.id);
        logger.info(`${email} is online`);
        io.emit("user-online", Array.from(userOnline.keys));
    });
}

export default userSocket;
