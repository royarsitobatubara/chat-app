import schema from "../lib/schema/contact-schema.js";

/**
 * 
 * @param {String} sender
 * @param {String} receiver 
 * @returns 
 */
const insert = async ({ sender, receiver }) => {
    return schema.create({
        emailSender: sender,
        emailReceiver: receiver
    });
}

const findAll = async () => {
    return schema.find();
}

/**
 * 
 * @param {String} sender 
 */
const findByEmailSender = async ({ sender }) => {
    return schema.find({ emailSender: sender });
}

/**
 * 
 * @param {String} sender 
 * @param {String} receiver 
 */
const findByEmailSenderAndReceiver = async ({ sender, receiver }) => {
    return schema.findOne({ emailSender: sender, emailReceiver: receiver });
}

/**
 * 
 * @param {String} id 
 */
const findById = async ({ id }) => {
    return schema.findOne({_id: id});
}

/**
 * 
 * @param {String} id 
 */
const deleteById = async ({ id }) => {
    return schema.deleteOne({ _id: id });
}

export default {
    insert,
    findAll,
    findByEmailSender,
    findByEmailSenderAndReceiver,
    findById,
    deleteById
};