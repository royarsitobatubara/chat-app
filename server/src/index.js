import express from "express";
import cors from "cors";
import dotenv from "dotenv";
import { createServer } from "http";
import { Server } from "socket.io";
import database from "./lib/database.js";
import userRoute from "./routes/user-route.js";
import contactRoute from "./routes/contact-route.js";
import socketHandler from "./sockets/index-socket.js";


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
    origin: "*",
    credentials: true
  },
});

// DATABASE
database();

// ROUTE
app.use('/api', userRoute);
app.use('/api', contactRoute);

// SOCKET HANDLER
socketHandler(io);

// PORT
const PORT = process.env.PORT || 3000;
httpServer.listen(PORT, () => {
  console.log(`Server run on port ${PORT}`);
});
