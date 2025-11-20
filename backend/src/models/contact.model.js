import logger from "../helpers/logger.js";
import contactSchema from "../lib/schema/contact-schema.js";

// MEMASUKAN CONTACT KE DATABASE
async function insert({ id, email_from, email_to }) {
  try {
    const doc = await contactSchema.create({ id, email_from, email_to });
    return doc;
  } catch (err) {
    logger.error(`ContactModel -> insert: ${err.message}`);
    throw err;
  }
}

// MENGAMBIL CONTACT DARI DATABASE BERDASARKAN EMAIL YANG DI TUJU
async function getByReceiverEmail({ email }) {
  try {
    return await contactSchema.findOne({ email_to: email });
  } catch (err) {
    logger.error(`ContactModel -> getByReceiverEmail: ${err.message}`);
    throw err;
  }
}

// MENGAMBIL CONTACT DARI DATABASE BERDASARKAN EMAIL KITA
async function getBySenderEmail({ email }) {
  try {
    return await contactSchema.find({ email_from: email });
  } catch (err) {
    logger.error(`ContactModel -> getBySenderEmail: ${err.message}`);
    throw err;
  }
}

// MENGAMBIL CONTACT DARI DATABASE BERDASARKAN EMAIL KITA DAN YANG DI TUJU
async function getBySenderAndReceiverEmail({ email_from, email_to }) {
  try {
    return await contactSchema.find({
      email_from: email_from,
      email_to: email_to,
    });
  } catch (err) {
    logger.error(`ContactModel -> getBySenderEmail: ${err.message}`);
    throw err;
  }
}

export default {
  insert,
  getByReceiverEmail,
  getBySenderEmail,
  getBySenderAndReceiverEmail,
};
