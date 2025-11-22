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
    logger.error(`POST /api/user/signup: ${err.message}`);

    return response.failed({
      res,
      status: err.status || 500,
      message: err.message || "internal server error"
    });
  }
});

userController.get('/search', async (req, res) => {
  const query = req.query.user;

  try {
    const data = await userService.getUserByEmailOrUsername({ keyword: query });

    return response.success({
      res,
      status: 200,
      message: "Success get data",
      data: data
    });

  } catch (err) {
    logger.error(`GET /api/user/search?user=${query} : ${err.message}`);
    return response.failed({
      res,
      status: err.status || 500,
      message: err.message || "internal server error"
    });
  }
});

userController.put('/update/username', async (req, res) => {
  const {email, username} = req.body;
  if (!username || !email) {
    logger.warn('username and email is required');
    return response.failed({
      res,
      status: 400,
      message: "Required username, email and password"
    });
  }
  try {
    const data = await userService.updateUsernameByEmail({email: email, username: username});

    return response.success({
      res,
      status: 200,
      message: "Username updated successfully",
      data: data
    });

  } catch (err) {
    logger.error(`PUT /api/user/update/username: ${err.message}`);
    return response.failed({
      res,
      status: err.status || 500,
      message: err.message || "internal server error"
    });
  }
});

userController.put('/update/password', async (req, res) => {
  const { email, passOld, passNew } = req.body;

  if (!email || !passOld || !passNew) {
    return response.failed({
      res,
      status: 400,
      message: "Required email, passOld, and passNew"
    });
  }

  try {
    const data = await userService.updatePasswordByEmail({
      email,
      passwordOld: passOld,
      passwordNew: passNew
    });

    return response.success({
      res,
      status: 200,
      message: "Password updated successfully",
      data: data
    });

  } catch (err) {
    logger.error(`PUT /api/user/update/password: ${err.message}`);
    return response.failed({
      res,
      status: err.status || 500,
      message: err.message || "internal server error"
    });
  }
});



export default userController;
