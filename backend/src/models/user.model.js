import userSchema from "../lib/schema/user-schema.js";
import logger from "../helpers/logger.js";

async function create({ id, username, email, password }) {
  try {
    return await userSchema.create({ id, username, email, password });
  } catch (error) {
    logger.error(`UserModel -> createUser: ${error.message}`);
    throw error;
  }
}

async function findByEmail(email) {
  try {
    return await userSchema.findOne({ email });
  } catch (error) {
    logger.error(`UserModel -> findByEmail: ${error.message}`);
    throw error;
  }
}

async function findByEmailAndPassword(email, password) {
  try {
    return await userSchema.findOne({ email, password });
  } catch (error) {
    logger.error(`UserModel -> findByEmailAndPassword: ${error.message}`);
    throw error;
  }
}

async function findByEmailOrUsername(keyword) {
  try {
    return await userSchema.find({
      $or: [
        { email: { $regex: keyword, $options: "i" } },
        { username: { $regex: keyword, $options: "i" } }
      ]
    }).select("-password");
  } catch (error) {
    logger.error(`UserModel -> findByEmailOrUsername: ${error.message}`);
    throw error;
  }
}



export default {
  create,
  findByEmail,
  findByEmailAndPassword,
  findByEmailOrUsername
};
