import express from "express";
import cors from "cors";
import dotenv from "dotenv";
import userController from "./controllers/user.controller.js";

// ENV
dotenv.config();

// MIDDLEWARE
const app = express();
app.use(express.json());
app.use(cors());

// ROUTE
app.get('/', (req, res) => {
    return res.status(200).json({
        success: true,
        message: "Server is run"
    });
});
app.use(userController);

// PORT
app.listen(process.env.PORT, () => {
    console.log(`Server run on port ${process.env.PORT}`);
});