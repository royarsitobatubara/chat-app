import userSchema from "../lib/schema/user-schema.js";
import logger from "../helpers/logger.js";

// MASUKAN USER KE DATABASE
async function create({ id, username, email, password }) {
  try {
    return await userSchema.create({ id, username, email, password, photo: null });
  } catch (err) {
    logger.err(`UserModel -> createUser: ${err.message}`);
    throw err;
  }
}

// MENGAMBIL SATU DATA USER SESUAI EMAIL
async function findByEmail(email) {
  try {
    return await userSchema.findOne({ email });
  } catch (err) {
    logger.err(`UserModel -> findByEmail: ${err.message}`);
    throw err;
  }
}

// MENGAMBIL SATU DATA USER SESUAI DENGAN EMAIL DAN PASSWORD
async function findByEmailAndPassword(email, password) {
  try {
    return await userSchema.findOne({ email, password });
  } catch (err) {
    logger.err(`UserModel -> findByEmailAndPassword: ${err.message}`);
    throw err;
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
  } catch (err) {
    logger.err(`UserModel -> findByEmailOrUsername: ${err.message}`);
    throw err;
  }
}

async function deleteAllCollection(params) {
  try {
    
  } catch (err) {
    logger.err(`UserModel -> deleteAllCollection: ${err.message}`);
    throw err;
  }
}

export default {
  create,
  findByEmail,
  findByEmailAndPassword,
  findByEmailOrUsername,
};
