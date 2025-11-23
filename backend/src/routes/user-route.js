import { Router } from "express";
import userController from "../controllers/user-controller.js";

const userRoute = Router();

userRoute.post('/user/signin', userController.signIn);
userRoute.post('/user/signup', userController.signUp);
userRoute.get('/user', userController.searchUser);
userRoute.patch('/user/update/username', userController.updateUsername);
userRoute.patch('/user/update/password', userController.updatePassword);

export default userRoute;