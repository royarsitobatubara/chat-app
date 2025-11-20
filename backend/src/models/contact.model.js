import logger from "../helpers/logger.js";
import contactSchema from "../lib/schema/contact-schema.js";

// INSERT
async function insert({ id, email_from, email_to }) {
  try {
    const doc = await contactSchema.create({ id, email_from, email_to });
    return doc;
  } catch (err) {
    logger.error(`ContactModel -> insert: ${err.message}`);
    throw err;
  }
}

// GET by receiver
async function getByReceiverEmail({ email }) {
  try {
    return await contactSchema.findOne({ email_to: email });
  } catch (err) {
    logger.error(`ContactModel -> getByReceiverEmail: ${err.message}`);
    throw err;
  }
}

// GET by sender
async function getBySenderEmail({ email }) {
  try {
    return await contactSchema.find({ email_from: email });
  } catch (err) {
    logger.error(`ContactModel -> getBySenderEmail: ${err.message}`);
    throw err;
  }
}

// GET by sender + receiver
async function getBySenderAndReceiverEmail({ email_from, email_to }) {
  try {
    return await contactSchema.findOne({ email_from, email_to });
  } catch (err) {
    logger.error(`ContactModel -> getBySenderAndReceiverEmail: ${err.message}`);
    throw err;
  }
}

// DELETE
async function deleteContactById({ id }) {
  try {
    return await contactSchema.deleteOne({ id });
  } catch (err) {
    logger.error(`ContactModel -> deleteContactById: ${err.message}`);
    throw err;
  }
}

export default {
  insert,
  getByReceiverEmail,
  getBySenderEmail,
  getBySenderAndReceiverEmail,
  deleteContactById
};
