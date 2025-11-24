import { Router } from "express";
import userController from "../controllers/user-controller.js";

const userRoute = Router();

userRoute.get('/user', userController.getAllUser);
userRoute.get('/user/search', userController.searchUser);
userRoute.post('/user/signin', userController.signIn);
userRoute.post('/user/signup', userController.signUp);
userRoute.patch('/user/update/username', userController.updateUsername);
userRoute.patch('/user/update/password', userController.updatePassword);
userRoute.delete('/user/:id', userController.deleteUserById);

export default userRoute;