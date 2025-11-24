import bcrypt from "bcrypt";
import AppError from "../helpers/app-error.js";
import model from "../models/user-model.js";
import token from "../helpers/generate-token.js";

/**
 * SIGN UP
 * @param {String} username
 * @param {String} email
 * @param {String} password
 */
const signUp = async ({ username, email, password }) => {
  const exists = await model.findByEmail({ email });
  if (exists) {
    throw new AppError("Email already used", 409);
  }

  const hashPassword = await bcrypt.hash(password, 10);

  let res;
  try {
    res = await model.insert({
      username,
      email,
      password: hashPassword,
    });
  } catch (err) {
    throw new AppError("Failed to create user", 500);
  }

  return res;
};

/**
 * SIGN IN
 * @param {String} email
 * @param {String} password
 */
const signIn = async ({ email, password }) => {
  const user = await model.findByEmail({ email });
  if (!user) {
    throw new AppError("Email not found", 404);
  }

  const match = await bcrypt.compare(password, user.password);
  if (!match) {
    throw new AppError("Password is wrong", 400);
  }
  const payload = {id: user.id, email: user.email};
  return {
    id: user.id,
    email: user.email,
    username: user.username,
    token: token({payload: payload})
  };
};


/**
 * GET ALL USER
 */
const getAllUser = async () => {
  const user = await model.findAll();
  if(user.length === 0){
    throw new AppError("User is empty", 404);
  }
  return user;
}

/**
 * SEARCH USER
 * @param {String} keyword 
 */
const searchUser = async (keyword) => {
  const user = await model.findByKeyword(keyword);
  if(!user || user.length === 0){
    throw new AppError('User not found', 404);
  }
  return user;
}

/**
 * UPDATE USERNAME
 * @param {String} email 
 * @param {String} password 
 */
const updateUsername = async ({ email, username }) => {
  const user = await model.updateUsername({email, username});
  if(!user || user.matchedCount === 0){
    throw new AppError("Failed update username", 400);
  }
  return user;
}

/**
 * UPDATE PASSWORD
 * @param {String} email 
 * @param {String} passwordOld 
 * @param {String} passwordNew
 */
const updatePassword = async ({ email, passwordOld, passwordNew }) => {
  const user = await model.findByEmail({email});
  if (!user){
    throw new AppError('User not found', 404);
  }
  const match = await bcrypt.compare(passwordOld, user.password);
  if(!match){
    throw new AppError('Password is wrong', 400);
  }
  const hash = await bcrypt.hash(passwordNew, 10);
  const updated = await model.updatePassword({ email, password: hash });
  if (updated.modifiedCount === 0) {
    throw new AppError("Failed to update password", 500);
  }
  return updated;
}

/**
 * DELETE USER BY ID
 * @param {String} id 
 */
const deleteUserById = async ({id}) => {
  const user = await model.findById({id});
  if (!user){
    throw new AppError("User not found", 404);
  }
  const res = await model.deleteById({id: user.id});
  if(res.deletedCount === 0){
    throw new AppError("Delete user failed", 500);
  }
  return res;
}

export default {
  signUp,
  signIn,
  searchUser,
  getAllUser,
  updateUsername,
  updatePassword,
  deleteUserById
};
