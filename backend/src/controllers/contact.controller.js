import express from "express";
import ContactModel from "../models/contact.model.js";
import response from "../helpers/response.helper.js";

const contactController = express.Router();
const endpoint = "/api/contact";

export default contactController;