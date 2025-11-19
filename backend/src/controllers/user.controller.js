import { Router } from "express";
import userService from "../services/user.service.js";
import response from "../helpers/response.js";
import logger from "../helpers/logger.js";

const userController = Router();

userController.post("/signin", async (req, res) => {
  const { email, password } = req.body;

  if (!email || !password) {
    return response.failed({
      res,
      status: 400,
      message: "Required email and password"
    });
  }

  try {
    const data = await userService.signin({ email, password });

    return response.success({
      res,
      status: 200,
      message: "Login is success",
      data
    });
  } catch (err) {
    logger.error(`[POST] /api/user/signin: ${err.message}`);

    return response.failed({
      res,
      status: err.status || 500,
      message: err.message || "internal server error"
    });
  }
});

userController.post("/signup", async (req, res) => {
  const { username, email, password } = req.body;

  if (!username || !email || !password) {
    return response.failed({
      res,
      status: 400,
      message: "Required username, email and password"
    });
  }

  try {
    const user = await userService.signup({ username, email, password });

    return response.success({
      res,
      status: 201,
      message: "Sign Up is success",
      data: {
        id: user.id,
        username: user.username,
        email: user.email
      }
    });
  } catch (err) {
    logger.error(`POST /signup: ${err.message}`);

    return response.failed({
      res,
      status: err.status || 500,
      message: err.message || "internal server error"
    });
  }
});

export default userController;
