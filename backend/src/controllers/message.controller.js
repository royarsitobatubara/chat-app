import messageService from "../services/message.service.js";
import response from "../helpers/response.js";
import logger from "../helpers/logger.js";

async function addMessage(req, res) {
  try {
    const data = req.body;

    const save = await messageService.addMessage(data);

    return response.success({
      res,
      message: "Message added",
      data: save,
    });
  } catch (err) {
    logger.error(`MessageController -> addMessage: ${err.message}`);
    return response.failed({
      res,
      status: err.status || 500,
      message: err.message || "Failed to add message",
    });
  }
}

async function deleteAllMessageByReceiver(req, res) {
  try {
    const { email } = req.params;

    const deleted = await messageService.deleteAllMessageByReceiver(email);

    return response.success({
      res,
      message: "Messages deleted",
      data: deleted,
    });
  } catch (err) {
    logger.error(`MessageController -> deleteAll: ${err.message}`);
    return response.failed({
      res,
      status: err.status || 500,
      message: err.message || "Failed to delete message",
    });
  }
}

async function getAllMessageReceiver(req, res) {
  try {
    const { email } = req.params;

    const data = await messageService.getAllMessageReceiver(email);

    return response.success({
      res,
      message: "Messages fetched",
      data,
    });
  } catch (err) {
    logger.error(`MessageController -> getAll: ${err.message}`);
    return response.failed({
      res,
      status: err.status || 500,
      message: err.message || "Failed to get messages",
    });
  }
}

export default {
  addMessage,
  deleteAllMessageByReceiver,
  getAllMessageReceiver,
};
