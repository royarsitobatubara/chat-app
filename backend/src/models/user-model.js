import schema from "../lib/schema/user-schema.js";

/**
 * INSERT USER
 * @param {String} username
 * @param {String} email
 * @param {String} password
 */
const insert = async ({ username, email, password }) => {
  return await schema.create({ username, email, password });
};

/**
 * FIND ONE USER BY EMAIL
 * @param {String} email
 */
const findByEmail = async ({ email }) => {
  return await schema.findOne({ email });
};

/**
 * FIND USER BY KEYWORD
 * @param {String} keyword 
 */
const findByKeyword = async (keyword) => {
  return await schema.find({
    $or: [
      { email : {$regex: keyword, $options: "i"}},
      { username : {$regex: keyword, $options: "i"} }
    ]
  });
}

/**
 * 
 * @param {String} email 
 * @param {String} username 
 */
const updateUsername = async ({ email, username }) => {
  return await schema.updateOne(
    {email: email},
    {$set: {username: username}}
  );
}

/**
 * 
 * @param {String} email 
 * @param {String} password 
 */
const updatePassword = async ({ email, password }) => {
  return await schema.updateOne(
    {email: email},
    {$set: {password: password}}
  );
}

export default {
  insert,
  findByEmail,
  findByKeyword,
  updateUsername,
  updatePassword
};
