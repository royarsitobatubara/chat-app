import userSchema from "../lib/schema/user-schema.js";
import logger from "../helpers/logger.js";

// MASUKAN USER KE DATABASE
async function create({ id, username, email, password }) {
  try {
    return await userSchema.create({ id, username, email, password, photo: null });
  } catch (error) {
    logger.error(`UserModel -> createUser: ${error.message}`);
    throw error;
  }
}

// MENGAMBIL SATU DATA USER SESUAI EMAIL
async function findByEmail(email) {
  try {
    return await userSchema.findOne({ email });
  } catch (error) {
    logger.error(`UserModel -> findByEmail: ${error.message}`);
    throw error;
  }
}

// MENGAMBIL SATU DATA USER SESUAI DENGAN EMAIL DAN PASSWORD
async function findByEmailAndPassword(email, password) {
  try {
    return await userSchema.findOne({ email, password });
  } catch (error) {
    logger.error(`UserModel -> findByEmailAndPassword: ${error.message}`);
    throw error;
  }
}

// MENGAMBIL SEMUA USER SESUAI DENGAN EMAIL ATAU PASSWORD
async function findByEmailOrUsername(keyword) {
  try {
    return await userSchema
      .find({
        $or: [
          { email: { $regex: keyword, $options: "i" } },
          { username: { $regex: keyword, $options: "i" } },
        ],
      })
      .select("-password");
  } catch (error) {
    logger.error(`UserModel -> findByEmailOrUsername: ${error.message}`);
    throw error;
  }
}

export default {
  create,
  findByEmail,
  findByEmailAndPassword,
  findByEmailOrUsername,
};
