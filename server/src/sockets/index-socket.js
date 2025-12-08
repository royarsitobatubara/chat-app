import { Server } from "socket.io";
import userSocket from "./user-socket.js";
import messageSocket from "./message-socket.js";
import logger from "../helpers/app-logger.js";


const userOnline = new Map();

/**
 * 
 * @param {Server} io 
 */
function socketHandler(io) {
    io.on("connection", (socket) => {
        
        userSocket(io, socket, userOnline);
        messageSocket(io, socket, userOnline)

        socket.on("disconnect", ()=> {
            for(const [email, id] of userOnline.entries()){
                if (id === socket.id){
                    userOnline.delete(email);
                    logger.info(`${email} disconnected`);
                    break;
                }
            }

            io.emit("user-online-list", Array.from(userOnline.keys()));
        });

    });
}

export default socketHandler;