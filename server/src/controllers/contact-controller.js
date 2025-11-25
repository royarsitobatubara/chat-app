import service from "../services/contact-service.js";
import AppResponse from "../helpers/app-response.js";
import logger from "../helpers/app-logger.js";

const addContact = async (req, res, next) => {
    const {sender, receiver} = req.body;
    if(!sender || !receiver) {
        logger.warn(`Sender: ${sender ?? null}, Receiver: ${receiver ?? null}`);
        return AppResponse.failed({
            res,
            statusCode: 400,
            message: "Sender and receiver cannot be empty"
        });
    }
    try {
        const data = await service.addContact({ sender, receiver });
        return AppResponse.success({
            res,
            statusCode: 200,
            message: "Add contact success",
            data
        });
    } catch (error) {
        logger.error(error);
        return AppResponse.failed({
            res,
            statusCode: error.statusCode || 500,
            message: error.message,
            error: error
        });
    }
}

const deleteContactById = async (req, res, next) => {
    const id = req.query.id;
    if(!id){
        logger.warn(`id: ${id}`);
        return AppResponse.failed({
            res,
            statusCode: 400,
            message: "ID require",
        });
    }
    try {
        const data = await service.deleteContactById({id});
        return AppResponse.success({
            res,
            statusCode: 200,
            message: "Delete contact success",
            data
        });
    } catch (error) {
        logger.error(error);
        return AppResponse.failed({
            res,
            statusCode: error.statusCode || 500,
            message: error.message,
            error: error
        });
    }
}

const getAllContacts = async (req, res, next) => {
    try {
        const data = await service.getAllContacts();
        return AppResponse.success({
            res,
            statusCode: 200,
            message: "Get contact success",
            data
        });
    } catch (error) {
        logger.error(error);
        return AppResponse.failed({
            res,
            statusCode: error.statusCode || 500,
            message: error.message,
            error
        });
    }
}

const getContactBySender = async (req, res, next) => {
    const { email } = req.params;
    try {
        const data = await service.getContactBySender({ sender: email });
        return AppResponse.success({
            res,
            statusCode: 200,
            message: "Get contact success",
            data
        });
    } catch (error) {
        logger.error(error);
        return AppResponse.failed({
            res,
            statusCode: error.statusCode || 500,
            message: error.message,
            error
        });
    }
};


export default {
    addContact,
    deleteContactById,
    getAllContacts,
    getContactBySender
};