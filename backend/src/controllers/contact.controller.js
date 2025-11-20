import { Router } from "express";
import contactService from "../services/contact.service.js";
import response from "../helpers/response.js";
import logger from "../helpers/logger.js";

const contactController = Router();

contactController.post("/add", async (req, res) => {
  const { email_from, email_to } = req.body;

  if (!email_from || !email_to) {
    return response.failed({
      res,
      status: 400,
      message: "email is required"
    });
  }

  try {
    const data = await contactService.addContact({ email_from, email_to });

    return response.success({
      res,
      status: 201,
      message: "success to add contact",
      data
    });
  } catch (err) {1
    logger.error(`POST /add: ${err.message}`);

    return response.failed({
      res,
      status: err.status || 500,
      message: err.message,
      data: err.data
    });
  }
});

contactController.get("/:email", async (req, res) => {
  const email = req.params.email;

  if (!email) {
    return response.failed({
      res,
      status: 400,
      message: "email is required"
    });
  }

  try {
    const data = await contactService.getContacts(email);

    return response.success({
      res,
      status: 200,
      message: "success get all contact",
      data
    });
  } catch (err) {
    logger.error(`GET /:email: ${err.message}`);

    return response.failed({
      res,
      status: err.status || 500,
      message: err.message,
      data: err.data
    });
  }
});

export default contactController;
