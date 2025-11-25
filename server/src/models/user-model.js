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
 * FIND ALL USER
 */
const findAll = async () => {
  return await schema.find();
};

/**
 * FIND ONE USER BY EMAIL
 * @param {String} email
 */
const findByEmail = async ({ email }) => {
  return await schema.findOne({ email });
};

/**
 * FIND ONE USER BY ID
 * @param {String} id
 */
const findById = async ({ id }) => {
  return await schema.findOne({ _id: id });
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
 * UPDATE USERNAME
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
 * UPDATE PASSWORD
 * @param {String} email 
 * @param {String} password 
 */
const updatePassword = async ({ email, password }) => {
  return await schema.updateOne(
    {email: email},
    {$set: {password: password}}
  );
}

/**
 * 
 * @param {String} id 
 */
const deleteById = async ({id}) => {
  return await schema.deleteOne({_id: id});
}

export default {
  insert,
  findAll,
  findById,
  findByEmail,
  findByKeyword,
  updateUsername,
  updatePassword,
  deleteById
};
