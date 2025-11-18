import logger from "../helpers/logger.js";
import contactSchema from "../lib/schema/contact-schema.js";

class ContactModel {

    static async insert({ id, email_from, email_to }){
        try {
            const result = await contactSchema.insertOne({ id: id, email_from: email_from, email_to: email_to});
            if(!result){
                logger.warn(`ContactModel -> insert: Failed to save contact`);
                return; 
            }
            return result;
        } catch (error) {
            logger.error(`ContactModel -> insert: ${error.message}`);
            throw error;
        }
    }

    static async getContactByEmail({ email }){
        try {
            const result = await contactSchema.find({ email_to: email });
            return result;
        } catch (error) {
            logger.error(`ContactModel -> getContactByEmail: ${error.message}`);
            throw error;
        }
    }

    static async getAllContactByEmail({ email }){
        try {
            const result = await contactSchema.find({ email_from: email});
            return result;
        } catch (error) {
            logger.error(`ContactModel -> getAllContactByEmail: ${error.message}`);
            throw error;
        }
    }

}

export default ContactModel;