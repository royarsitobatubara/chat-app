import {Router} from "express";
import ContactModel from "../models/contact.model.js";
import UserModel from "../models/user.model.js";
import response from "../helpers/response.js";
import logger from "../helpers/logger.js";
import generateUUID from "../helpers/generateuuid.js";

const contactController = Router();

contactController.post('/add', async (req, res) => {
    const {email_from, email_to} = req.body;
    if(!email_from || !email_to){
        logger.error(`Request body [email_from]: ${email_from}, [email_to]: ${email_to}`);
        return response.failed({
            res,
            status: 400,
            message: 'Email from and to is required!'
        }); 
    }
    try {
        const checkContact = await ContactModel.getContactByEmail({ email: email_to});
        if(checkContact){
            logger.warn(`contact is already exist`);
            return response.failed({
                res,
                status: 409,
                message: 'Contact is already exist'
            }); 
        }

        const checkUser = await UserModel.getUserByEmail({ email: email_to });
        if(!checkUser){
            logger.warn(`CheckUser: ${checkUser}`);
            return response.failed({
                res,
                status: 404,
                message: 'User is not found'
            }); 
        }

        const data = await ContactModel.insert({
            id: generateUUID(),
            email_from: email_from,
            email_to: email_to
        });
        if(!data){
            logger.warn('contactController /api/user/add: Failed to insert contact');
            return response.failed({
                res,
                status: 400,
                message: 'Failed to save contact'
            });
        }
        return response.success({
            res,
            status: 201,
            message: "Success to insert contact",
            data: {
                id: data.id,
                email_from: data.email_from,
                email_to: data.email_to
            }
        });
    } catch (error) {
        logger.error(`contactController /api/user/add: ${error}`)
        return response.failed({
            res,
            status: 500,
            message: 'Server have something wrong',
            error: error.message
        });
    }
});

contactController.get('/:email', async (req, res) => {
    const email = req.params.email;
    if(!email){
        logger.error(`Request params email: ${email}`);
        return response.failed({
            res,
            status: 400,
            message: 'Email is required!'
        }); 
    }
    try {
        const data = await ContactModel.getAllContactByEmail({ email: email });
        if(data.length === 0){
            return response.success({
                res,
                status: 404,
                message: "Contact is not found",
                data: data
            });
        }
        return response.success({
            res,
            status: 200,
            message: "Success get all contact",
            data: data
        });
    } catch (error) {
        logger.error(`contactController /api/user/:email : ${error}`)
        return response.failed({
            res,
            status: 500,
            message: 'Server have something wrong',
            error: error.message
        });
    }
});

export default contactController;