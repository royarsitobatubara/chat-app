import logger from "../helpers/logger.js";
import messageSchema from "../lib/schema/message-schema.js";

class MessageModel {

  static async insert({ data }) {
    try {
      const message = await messageSchema.create({
        id: data.id,
        from: data.from,
        to: data.to,
        type: data.type,
        isRead: data.isRead,
        time: data.time
      });
      return message;
    } catch (error) {
      logger.error(`MessageModel -> insert: ${error.message}`);
      throw error;
    }
  }

  static async delete({ data }) {
    try {
      return await messageSchema.deleteMany({ to: data.to });
    } catch (error) {
      logger.error(`MessageModel -> delete: ${error.message}`);
      throw error;
    }
  }

  static async get({ data }) {
    try {
      const messages = await messageSchema.find({
        to: data.to
      }).lean();

      return messages || [];
    } catch (error) {
      logger.error(`MessageModel -> get: ${error.message}`);
      throw error;
    }
  }

}

export default MessageModel;
