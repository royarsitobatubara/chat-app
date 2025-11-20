import ContactModel from "../models/contact.model.js";
import UserModel from "../models/user.model.js";
import logger from "../helpers/logger.js";

async function addContact({ email_from, email_to }) {
  const exist = await ContactModel.getBySenderAndReceiverEmail({
    email_from,
    email_to,
  });
  if (exist && exist.length > 0) {
    const err = new Error("the contact is already exists");
    err.status = 409;
    throw err;
  }

  const user = await UserModel.findByEmail(email_to);
  if (!user) {
    const err = new Error("user is not found");
    err.status = 404;
    throw err;
  }

  const save = await ContactModel.insert({
    email_from,
    email_to,
  });

  if (!save) {
    const err = new Error("failed to save contact");
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
    const err = new Error("contact not found");
    err.status = 404;
    err.data = [];
    throw err;
  }

  return data;
}

export default { addContact, getContacts };
