import messageModel from "../models/message.model.js";
import logger from "../helpers/logger.js";

async function addMessage({ message, from, to, type, isRead, time }) {
  try {
    const saved = await messageModel.insert({ message, from, to, type, isRead, time });
    logger.info(`Message added: ${saved.message}`);
    return saved;
  } catch (err) {
    logger.error(`messageService -> addMessage: ${err.message}`);
    err.status = 400;
    throw err;
  }
}

async function deleteAllMessageByReceiver(to) {
  try {
    const deleted = await messageModel.deleteByReceiver({ to });
    if (!deleted || deleted.deletedCount === 0) {
      const err = new Error("no message deleted");
      err.status = 404;
      throw err;
    }
    logger.info(`Message deleted: ${deleted.deletedCount}`);
    return deleted;
  } catch (err) {
    logger.error(`messageService -> deleteAllMessageByReceiver: ${err.message}`);
    throw err;
  }
}

async function getAllMessageReceiver(to) {
  try {
    const data = await messageModel.getByReceiver({ to });
    
    // Jangan lempar error jika kosong, kembalikan array kosong
    if (!data || data.length === 0) {
      logger.info(`No pending messages for ${to}`);
      return [];
    }

    logger.info(`Messages retrieved for ${to}: ${data.length}`);
    return data;
  } catch (err) {
    logger.error(`messageService -> getAllMessageReceiver: ${err.message}`);
    throw err;
  }
}


export default {
  addMessage,
  deleteAllMessageByReceiver,
  getAllMessageReceiver,
};
