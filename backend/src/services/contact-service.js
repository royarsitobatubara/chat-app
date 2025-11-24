import modelContact from "../models/contact-model.js";
import modelUser from "../models/user-model.js";
import AppError from "../helpers/app-error.js";

/**
 * 
 * @param {String} sender 
 * @param {String} receiver 
 */
const addContact = async ({ sender, receiver}) => {
    const user = await modelUser.findByEmail({email: receiver});
    if(!user){
        throw new AppError("User not found", 404);
    }
    const exist = await modelContact.findByEmailSenderAndReceiver({ sender, receiver });
    if(exist){
        throw new AppError("Contact already exist", 409);
    }
    const contact = await modelContact.insert({ sender, receiver });
    if(!contact){
        throw new AppError("Failed add contact", 500);
    }
    return {
        contact: {
            id: contact.id,
            sender: contact.emailSender,
            receiver: contact.emailReceiver
        },
        user: {
            id: user.id,
            username: user.username,
            email: user.email
        }
    }
}

const getAllContacts = async () => {
    const contacts = await modelContact.findAll();
    if(contacts.length === 0 || !contacts){
        throw new AppError("Contact is empty", 404);
    }
    return contacts;
}

/**
 * 
 * @param {String} sender 
 */
const getContactBySender = async ({ sender })  => {
    const contacts = await modelContact.findByEmailSender({sender});
    if(contacts.length === 0){
        throw new AppError("Contact is empty", 404);
    }
    return contacts;
}

/**
 * 
 * @param {String} receiver 
 */
const getContactByReceiver = async ({ receiver })  => {
    const contacts = await modelContact.findByEmailReceiver({receiver});
    if(contacts.length === 0){
        throw new AppError("Contact is empty", 404);
    }
    return contacts;
}

/**
 * 
 * @param {String} id 
 */
const deleteContactById = async ({ id }) => {
    const exist = await modelContact.findById({ id });
    if(!exist){
        return new AppError("Contact not found", 404);
    }
    const result = await modelContact.deleteById({id: exist.id});
    if(!result || result.deletedCount === 0){
        throw new AppError("Failed delete contact", 500);
    }
    return result;
}

export default {
    addContact,
    getAllContacts,
    deleteContactById,
    getContactBySender,
    getContactByReceiver
}