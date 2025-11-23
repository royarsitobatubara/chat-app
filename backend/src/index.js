import express from "express";
import cors from "cors";
import dotenv from "dotenv";
import { createServer } from "http";
import { Server } from "socket.io";
import database from "./lib/database.js";
import userRoute from "./routes/user-route.js";


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
database();

// ROUTE
app.use('/api', userRoute);

// SOCKET IO

// PORT
const PORT = process.env.PORT || 3000;
httpServer.listen(PORT, () => {
  console.log(`Server run on port ${PORT}`);
});
