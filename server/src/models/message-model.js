import schema from "../lib/schema/message-schema.js";

/**
 * @param {String} id
 * @param {String} emailSender 
 * @param {String} emailReceiver 
 * @param {String} message 
 * @param {String} type 
 * @param {String} status 
 * @param {String} time 
 */
const insert = async({ id, emailSender, emailReceiver, message, type, status, time })=> {
    return await schema.create({ id, emailSender, emailReceiver, message, type, status, time });
}

/**
 * 
 * @param {String} email 
 */
const findSentMessages = async(email)=> {
    return await schema.find({emailReceiver: email, status: "sent"});
}

/**
 * 
 * @param {String} id 
 */
const deleteMessage = async(id)=> {
    return await schema.deleteOne({id});
}

export default {
    insert,
    findSentMessages,
    deleteMessage
};