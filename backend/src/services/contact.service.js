import ContactModel from "../models/contact.model.js";
import UserModel from "../models/user.model.js";
import logger from "../helpers/logger.js";

async function addContact({ email_from, email_to }) {
  const exist = await ContactModel.getBySenderAndReceiverEmail({
    email_from,
    email_to,
  });
  if (exist) {
    const err = new Error("Contact already exist");
    err.status = 409;
    throw err;
  }

  const user = await UserModel.findByEmail(email_to);
  if (!user) {
    const err = new Error("User not found");
    err.status = 404;
    throw err;
  }

  const save = await ContactModel.insert({
    email_from,
    email_to,
  });

  if (!save) {
    const err = new Error("Failed add contact");
    err.status = 400;
    throw err;
  }

  logger.info(`Contact added: ${email_from} -> ${email_to}`);
  return {
    contact: {
      id: save.id,
      email_from: save.email_from,
      email_to: save.email_to
    },
    user: {
      id: user.id,
      username: user.username,
      email: user.email,
      photo: user.photo
    }
  };
}

async function getContacts(email) {
  const data = await ContactModel.getBySenderEmail({ email });

  if (!data || data.length === 0) {
    const err = new Error("Contact not found");
    err.status = 404;
    err.data = [];
    throw err;
  }

  return data;
}

async function deleteContactById({ id }) {
  const data = await ContactModel.deleteContactById({ id: id });

  if(!data || data.deletedCount === 0){
    const err = new Error("Failed delete contact");
    err.status = 400;
    throw err;
  }

  return data;
}

export default { addContact, getContacts, deleteContactById };
