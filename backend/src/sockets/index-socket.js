import { Server } from "socket.io";
import userSocket from "./user-socket.js";

/**
 * 
 * @param {Server} io 
 */
function socketHandler(io) {
    io.on("connection", (socket) => {
        
        userSocket(io, socket);
        
    });
}

export default socketHandler;