import express from "express";
import bcrypt from "bcrypt";
import jwt from "jsonwebtoken"
import dotenv from "dotenv";
import UserModel from "../models/user.model.js";
import response from "../helpers/response.helper.js";
import generateUUID from "../helpers/generateuuid.helper.js";

dotenv.config();
const userController = express.Router();

userController.post("/signin", async (req, res) => {
     console.log("req.body:", req.body);
    const {email, password} = req.body;
    if(!email || !password){
        return response.failed({res, status: 400, message: "Required email and password"});
    }
    try {
        const user = await UserModel.getUserByEmail({email: email});
        if(!user) return response.failed({res, status: 404, message: "Email and password is wrong"});

        const passCheck = await bcrypt.compare(password, user.password);
        if(!passCheck) return response.failed({res, status: 400, message: "Email and password is wrong"});

        const token = jwt.sign(
            {id: user.id, email: user.email},
            process.env.JWT_SECRET,
            {expiresIn: '365d'}
        )

        return response.success({
            res,
            status: 200,
            message: "Login is success",
            data: {
                id: user.id,
                username: user.username,
                email: user.email,
                photo: user.photo,
                token: token
            }
        });
    } catch (error) {
        return response.failed({res, status: 500, message: "Server have something wrong", error: error.message});
    }
});

userController.post(`/signup`, async (req, res) => {
    const {username, email, password} = req.body;
    if(!username || !email || !password){
        return response.failed({res, status: 400, message: "Required username, email and password"});
    }
    try {
        const emailCheck = await UserModel.getUserByEmail({email: email});
        if(emailCheck != null){
            return response.failed({res, status: 400, message: "Email is already exist"});
        }
        const passwordHash = await bcrypt.hash(password, 10);
        const data = await UserModel.create({
            id: generateUUID(),
            username: username,
            email: email,
            password: passwordHash
        });
        if(!data){
            return response.failed({res, status: 400, message: "Failed to signup"});
        }
        return response.success({
            res,
            status: 201,
            message: "Sign Up is success",
            data: {
                id: data.id,
                username: data.username,
                email: data.email
            }
        });
    } catch (error) {
        return response.failed({res, status: 500, message: "Server have something wrong", error: error.message});
    }
});


export default userController;