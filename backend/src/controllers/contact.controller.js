import {Router} from "express";
import ContactModel from "../models/contact.model.js";
import response from "../helpers/response.js";
import logger from "../helpers/logger.js";

const contactController = Router();

export default contactController;