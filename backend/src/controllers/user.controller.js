import express from "express";
import bcrypt from "bcrypt";
import jwt from "jsonwebtoken"
import dotenv from "dotenv";
import UserModel from "../models/user.model.js";
import response from "../helpers/response.helper.js";

dotenv.config();
const userController = express.Router();
const endpoint = "/api/user";

userController.get(`${endpoint}/signIn`, async(req, res) => {
    const {email, password} = req.body;
    if(!email || !password){
        return response.failed({
            res,
            status: 400,
            message: "Email dan password is required",
            error: null
        });
    }
    try {
        // Check email
        const user = await UserModel.getUserByEmail({email});
        if (!user) return response.failed({
            res,
            status: 404,
            message: "Email is not found",
            error: null
        });
        // Check password
        const check = await bcrypt.compare(password, user.password);
        if (!check) return response.failed({
            res,
            status: 400,
            message: "Password is wrong",
            error: null
        });

        const token = jwt.sign(
            {id: user.id, email: user.email},
            process.env.JWT_SECRET,
            {expiresIn: "365d"}
        );

        return response.success({
            res,
            status: 200,
            message: "Sign in is success",
            data: {
                id: user.id,
                username: user.username,
                email: user.email,
                photo: user.photo,
                token: token
            }
        });

    } catch (error) {
        return;
    }
});

userController.post(`${endpoint}/signUp`, (req, res) => {
    try {
        
    } catch (error) {
        
    }
});


export default userController;