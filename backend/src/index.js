import express from "express";
import cors from "cors";
import dotenv from "dotenv";
import { createServer } from "http";
import { Server } from "socket.io";
import userController from "./controllers/user.controller.js";
import contactController from "./controllers/contact.controller.js";
import chatSocket from "./socket/chatSocket.js";
import contactSocket from "./socket/contactSocket.js";
import db from "./lib/db.js";

// ENV
dotenv.config();

// MIDDLEWARE
const app = express();
const httpServer = createServer(app);
app.use(express.json());
app.use(cors());
app.use(express.urlencoded({ extended: true }));
const io = new Server(httpServer, {
    cors: {
        origin: "*"
    }
});

// DATABASE
db();

// ROUTE
app.get('/', (req, res) => {
    return res.status(200).json({
        success: true,
        message: "Server is run"
    });
});
app.use("/api/user", userController);
app.use("/api/contact", contactController);

// SOCKET IO
chatSocket(io);
contactSocket(io);

// PORT
httpServer.listen(process.env.PORT, () => {
    console.log(`Server run on port ${process.env.PORT}`);
});