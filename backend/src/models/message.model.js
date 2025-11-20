import messageSchema from "../lib/schema/message-schema.js";
import logger from "../helpers/logger.js";

async function insert({ message, sender, receiver, type, isRead, time }) {
  try {
    return await messageSchema.create({
      message,
      sender,
      receiver,
      type,
      isRead,
      time,
    });
  } catch (err) {
    logger.error(`MessageModel -> insert: ${err.message}`);
    throw err;
  }
}

async function deleteByReceiver({ to }) {
  try {
    return await messageSchema.deleteMany({ to });
  } catch (err) {
    logger.error(`MessageModel -> deleteByReceiver: ${err.message}`);
    throw err;
  }
}

async function getByReceiver({ to }) {
  try {
    return await messageSchema.find({ to }).lean();
  } catch (err) {
    logger.error(`MessageModel -> getByReceiver: ${err.message}`);
    throw err;
  }
}

export default { insert, deleteByReceiver, getByReceiver };
