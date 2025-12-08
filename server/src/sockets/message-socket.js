import { Server, Socket } from "socket.io";
import logger from "../helpers/app-logger.js";
import model from "../models/message-model.js";

/**
 * CONTACT SOCKET
 * @param {Server} io 
 * @param {Socket} socket 
 * @param {Map} userOnline 
 */
export default function messageSocket(io, socket, userOnline) {

    socket.on('send-message', async (data) => {
        const { id, emailSender, emailReceiver, message, type, time } = data;

        // Kasih status balik ke pengirim bahwa pesan sudah di-"send"
        socket.emit('update-message', {
            id,
            status: 'send'
        });

        try {
            // Jika penerima online
            if (userOnline.has(emailReceiver)) {
                const receiverSocketId = userOnline.get(emailReceiver);
                // kirim pesan ke penerima
                io.to(receiverSocketId).emit('receive-message', {
                    id, emailSender, emailReceiver, message, type, status: 'delivered', time
                });
                // kirim feedback ke pengirim
                socket.emit('update-message', {
                    id,
                    status: 'send'
                });
                logger.info(`Message delivered to ${emailReceiver}`);
            } else {
                // penerima offline → simpan ke DB nanti
                await model.insert(id, emailSender, emailReceiver, message, type, 'send', time);
                logger.info(`User ${emailReceiver} offline, message stored`);
            }

        } catch (err) {
            logger.error(`send-message: ${err}`);
        }
    });

}
