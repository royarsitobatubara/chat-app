import messageService from "../services/message.service.js";
import logger from "../helpers/logger.js";

export default function messageSocket(io) {
  const onlineUsers = {};

  io.on("connection", (socket) => {
    socket.on("register", async (email) => {
      try {
        onlineUsers[email] = socket.id;

        const pendingMessages = await messageService.getAllMessageReceiver(
          email
        );
        if (pendingMessages.length > 0) {
          pendingMessages.forEach((msg) =>
            io.to(socket.id).emit("receive_message", msg)
          );
          await messageService.deleteAllMessageByReceiver(email);
        }

        logger.info(`ONLINE ${email}: ${socket.id}`);
      } catch (err) {
        logger.error(`socket register error: ${err.message}`);
      }
    });

    socket.on("send_message", async (data) => {
      try {
        const targetSocket = onlineUsers[data.to];
        if (targetSocket) {
          io.to(targetSocket).emit("receive_message", data);
        } else {
          await messageService.addMessage(data);
        }
      } catch (err) {
        logger.error(`socket send_message error: ${err.message}`);
      }
    });

    socket.on("receive_message", (msg) => {
      console.log("Pesan diterima:", msg);
    });

    socket.on("disconnect", () => {
      for (let email in onlineUsers) {
        if (onlineUsers[email] === socket.id) {
          delete onlineUsers[email];
          logger.info(`OFFLINE ${email}: ${socket.id}`);
          break;
        }
      }
    });
  });
}
