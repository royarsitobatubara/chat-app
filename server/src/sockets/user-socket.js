import { Server, Socket } from "socket.io";
import logger from "../helpers/app-logger.js";
import modelMsg from "../models/message-model.js";

/**
 * CONTACT SOCKET
 * @param {Server} io 
 * @param {Socket} socket 
 * @param {Map} userOnline 
 */

export default function userSocket(io, socket, userOnline) {

  
  // USER REGISTER ONLINE
  socket.on("user-register", async(email) => {
    if (!email) return;
    userOnline.set(email, socket.id);
    socket.join(email);
    logger.info(`${email} is online, id: ${socket.id}`);
    io.emit("user-online-list", Array.from(userOnline.keys()));
    try {
      // ambil message berdasarkan email dan send dari database
      const sendMessage = await modelMsg.findSentMessages(email);
      // kirim ke receiver
      for(const msg of sendMessage){
        io.to(socket.id).emit("receive-message", {
          id: msg.id,
          emailSender: msg.emailSender,
          emailReceiver: msg.emailReceiver,
          message: msg.message,
          type: msg.type,
          time: msg.time,
          status: "delivered"
        });
      }
      // kirim feedback ke pengirim
      if (userOnline.has(msg.pengirim)) {
        io.to(userOnline.get(msg.pengirim)).emit("update-message", {
          id: msg.idchat,
          status: "delivered"
        });
      }
    } catch (error) {
      logger.error(`deliver pending messages error: ${error}`);
    }
  });

  // HANDLE DISCONNECT
  socket.on("disconnect", () => {
    for (const [email, id] of userOnline.entries()) {
      if (id === socket.id) {
        userOnline.delete(email);
        logger.info(`${email} disconnected`);
        io.emit("user-online-list", Array.from(userOnline.keys()));
        break;
      }
    }
  });
}

