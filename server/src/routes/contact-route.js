import { Router } from "express";
import controller from "../controllers/contact-controller.js";

const contactRoute = Router();

contactRoute.post('/contact', controller.addContact);
contactRoute.delete('/contact', controller.deleteContactById);
contactRoute.get('/contact/:email', controller.getContactBySender);
contactRoute.get('/contact', controller.getAllContacts);

export default contactRoute;