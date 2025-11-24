import modelContact from "../models/contact-model.js";
import modelUser from "../models/user-model.js";
import AppError from "../helpers/app-error.js";

/**
 * ADD CONTACT
 * @param {String} sender 
 * @param {String} receiver 
 */
const addContact = async ({ sender, receiver}) => {
    // mengecek apakah user anjing ni ada
    const user = await modelUser.findByEmail({email: receiver});
    // jika tidak maka tampilkan error
    if(!user){
        throw new AppError("User not found", 404);
    }
    // mengecek jika contact sudah ada apa tidak
    const exist = await modelContact.findByEmailSenderAndReceiver({ sender, receiver });
    // jika ada maka tampilkan error
    if(exist){
        throw new AppError("Contact already exist", 409);
    }
    // masukan data contact ke database
    const contact = await modelContact.insert({ sender, receiver });
    // jika tidak bisa maka tampilkan error kontol ini
    if(!contact){
        throw new AppError("Failed add contact", 500);
    }
    // mengembalikan nilai jika berhasil bujang
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

/**
 * GET ALL CONTACTS
 */
const getAllContacts = async () => {
    // mengambil data dari database
    const contacts = await modelContact.findAll();
    // jika tidak ada maka tampilkan kalo data kosong anjing
    if(contacts.length === 0 || !contacts){
        throw new AppError("Contact is empty", 404);
    }
    // jika ada maka mengembalikan array
    return contacts;
}

/**
 * GET ALL CONTACTS BY EMAIL SENDER
 * @param {String} sender 
 */
const getContactBySender = async ({ sender })  => {
    // mengambil data dari database sesuai email sender
    const contacts = await modelContact.findByEmailSender({sender});
    // jika tidak ada maka tampilkan kalo data kosong anjing
    if(contacts.length === 0){
        throw new AppError("Contact is empty", 404);
    }
    // jika ada maka mengembalikan array
    return contacts;
}

/**
 * GET ALL CONTACTS BY EMAIL RECEIVER
 * @param {String} receiver 
 */
const getContactByReceiver = async ({ receiver })  => {
    // mengambil data dari database sesuai email receiver
    const contacts = await modelContact.findByEmailReceiver({receiver});
    // jika tidak ada maka tampilkan kalo data kosong anjing
    if(contacts.length === 0){
        throw new AppError("Contact is empty", 404);
    }
    // jika ada maka mengembalikan array
    return contacts;
}

/**
 * DELETE CONTACT BY ID
 * @param {String} id 
 */
const deleteContactById = async ({ id }) => {
    // mengecek apakah user kontol ni ada di database
    const exist = await modelContact.findById({ id });
    // jika tidak ada maka tampilkan error
    if(!exist){
        return new AppError("Contact not found", 404);
    }
    // mencoba menghapus contact
    const result = await modelContact.deleteById({id: exist.id});
    // jika gagal maka tampilkan error
    if(!result || result.deletedCount === 0){
        throw new AppError("Failed delete contact", 500);
    }
    // jika berhasil maka kembalikan value
    return result;
}

export default {
    addContact,
    getAllContacts,
    deleteContactById,
    getContactBySender,
    getContactByReceiver
}