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
    logger.error(`POST /api/contact/add: ${err.message}`);

    return response.failed({
      res,
      status: err.status || 500,
      message: err.message || 'internal server error',
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
      message: "Email is required"
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
    logger.error(`GET /api/contact/:email: ${err.message}`);

    return response.failed({
      res,
      status: err.status || 500,
      message: err.message || 'internal server error',
      data: err.data
    });
  }
});

contactController.delete('/:id', async (req, res) => {
  const { id } = req.params;

  if (!id) {
    return response.failed({
      res,
      status: 400,
      message: "Id is required"
    });
  }

  try {
    const data = await contactService.deleteContactById({ id });

    return response.success({
      res,
      status: 200,
      message: "Success delete contact",
      data
    });

  } catch (err) {
    logger.error(`DELETE /api/contact/:id: ${err.message}`);

    return response.failed({
      res,
      status: err.status || 500,
      message: err.message || 'internal server error'
    });
  }
});


export default contactController;
