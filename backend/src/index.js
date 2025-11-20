import express from "express";
import cors from "cors";
import dotenv from "dotenv";
import { createServer } from "http";
import { Server } from "socket.io";
import userController from "./controllers/user.controller.js";
import contactController from "./controllers/contact.controller.js";
import messageSocket from "./socket/messageSocket.js";
import contactSocket from "./socket/contactSocket.js";
import db from "./lib/db.js";
import ResponseHelper from "./helpers/response.js";
import logger from "./helpers/logger.js";

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
  },
});

// DATABASE
db();

// ROUTE
app.get("/api/ping", (req, res) => {
  logger.info("Ping success");
  return ResponseHelper.success({
    res,
    status: 200,
    message: "Ping is success",
  });
});
app.use("/api/user", userController);
app.use("/api/contact", contactController);

// SOCKET IO
messageSocket(io);
contactSocket(io);

const PORT = process.env.PORT || 3000;

// PORT
httpServer.listen(PORT, () => {
  console.log(`Server run on port ${PORT}`);
});
