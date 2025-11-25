import { Server, Socket } from "socket.io";
import userService from "../services/user-service.js";
import contactService from "../services/contact-service.js";
import logger from "../helpers/app-logger.js";
import contactModel from "../models/contact-model.js";

const onlineUsers = new Map();

/**
 * CONTACT SOCKET
 * @param {Server} io 
 * @param {Socket} socket 
 */
async function userSocket(io, socket) {

    /**
     * UPDATE USERNAME
     */
    socket.on("user:update-username", async(data)=> {
        const {email, newUsername} = data;
        try {
            await userService.updateUsername({email, username: newUsername});
            const contacts = await contactService.getContactByReceiver({receiver: email});

            contacts.forEach(contact => {
                const ownerEmail = contact.emailSender;
                io.to(ownerEmail).emit("user:updated:username", {
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


    /**
     * JOIN USER / ONLINE
     */
    socket.on("user:online", async (email) => {
        if (!email) return;
        try {
            onlineUsers.set(email, socket.id);
            socket.join(email);
            const owners = await contactModel.findByEmailReceiver({receiver: email});
            owners.forEach(owner => {
                io.to(owner.emailSender).emit("user:online", { email });
            });
            logger.info(`${email} is online`);
        } catch (error) {
            logger.error(`Socket user:join error: ${error}`);
            socket.emit("error", {message: `${email} failed join`});
        }
    });

    /**
     * DISCONNECT / OFFLINE
     */
    socket.on("disconnect", async () => {
        let currentEmail = null;

        for (const [email, id] of onlineUsers.entries()) {
            if (id === socket.id) {
                currentEmail = email;
                onlineUsers.delete(email);
                break;
            }
        }

        if (!currentEmail) return;

        const contacts = await contactService.getContactBySender({sender: currentEmail});
        contacts.forEach(contact => {
            const ownerEmail = contact.emailReceiver;
            io.to(ownerEmail).emit("user:offline", {
                email: currentEmail
            });
            logger.warn(`${currentEmail} is Offline`);
        });
    });

}

export default userSocket;
