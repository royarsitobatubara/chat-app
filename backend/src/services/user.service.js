import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";
import UserModel from "../models/user.model.js";
import logger from "../helpers/logger.js";
import dotenv from "dotenv";

dotenv.config();

async function signup({ username, email, password }) {
  const exist = await UserModel.findByEmail(email);

  if (exist) {
    const err = new Error("Email is already exist");
    err.status = 400;
    throw err;
  }

  const hashed = await bcrypt.hash(password, 10);

  const user = await UserModel.create({
    username,
    email,
    password: hashed,
  });

  if (!user) {
    const err = new Error("Failed to signup");
    err.status = 400;
    throw err;
  }

  logger.info(`${user.email} is registered`);
  return user;
}

async function signin({ email, password }) {
  const user = await UserModel.findByEmail(email);

  if (!user) {
    const err = new Error("Email and password is wrong");
    err.status = 404;
    throw err;
  }

  const passCheck = await bcrypt.compare(password, user.password);
  if (!passCheck) {
    const err = new Error("Password is wrong");
    err.status = 400;
    throw err;
  }

  const token = jwt.sign(
    { id: user.id, email: user.email },
    process.env.JWT_SECRET,
    { expiresIn: "365d" }
  );

  logger.info(`${user.email} is login`);

  return {
    id: user.id,
    username: user.username,
    email: user.email,
    photo: user.photo,
    token,
  };
}

async function getUserByEmailOrUsername({ keyword }) {
  const user = await UserModel.findByEmailOrUsername(keyword);

  if (!user || user.length === 0) {
    const err = new Error("User is not found");
    err.status = 404;
    throw err;
  }

  return user;
}


// UPDATE

async function updateUsernameByEmail({ email, username }) {
  const res = await UserModel.findByEmail(email);
  if (!res) {
    const err = new Error("User not found");
    err.status = 404;
    throw err;
  }
  const user = await UserModel.updateUsernameByEmail({
    email: email,
    username: username
  });
  if (user.modifiedCount === 0) {
    const err = new Error("Failed update username");
    err.status = 400;
    throw err;
  }

  return user;
}


async function updatePasswordByEmail({ email, passwordOld, passwordNew }) {
  const user = await UserModel.findByEmail(email);

  if (!user) {
    const err = new Error("User not found");
    err.status = 404;
    throw err;
  }

  const passOld = user.password;
  const passCheck = await bcrypt.compare(passwordOld, passOld);

  if (!passCheck) {
    const err = new Error("Password is wrong");
    err.status = 400;
    throw err;
  }

  const passNew = await bcrypt.hash(passwordNew, 10);

  const result = await UserModel.updatePasswordByEmail({
    email: email,
    password: passNew
  });

  if (!result || result.modifiedCount === 0) {
    const err = new Error("Failed to update password");
    err.status = 400;
    throw err;
  }

  return result;
}


export default { signup, signin, getUserByEmailOrUsername, updateUsernameByEmail, updatePasswordByEmail };
