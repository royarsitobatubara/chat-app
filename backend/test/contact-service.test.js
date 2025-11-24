import { jest } from "@jest/globals";

jest.unstable_mockModule("../src/models/contact-model.js", () => ({
  default: {
    findByEmailSender: jest.fn(),
    findByEmailReceiver: jest.fn(),
    findById: jest.fn(),
    insert: jest.fn(),
    deleteById: jest.fn(),
    findAll: jest.fn(),
    findByEmailSenderAndReceiver: jest.fn()
  }
}));

jest.unstable_mockModule("../src/models/user-model.js", () => ({
  default: {
    findByEmail: jest.fn()
  }
}));

// import setelah mock selesai
const contactService = (await import("../src/services/contact-service.js")).default;
const modelContact = (await import("../src/models/contact-model.js")).default;
const modelUser = (await import("../src/models/user-model.js")).default;
const AppError = (await import("../src/helpers/app-error.js")).default;

describe("Contact Service", () => {

  describe("addContact", () => {

    it("should throw error when receiver user not found", async () => {
      modelUser.findByEmail.mockResolvedValue(null);

      await expect(
        contactService.addContact({ sender: "a@a.com", receiver: "b@b.com" })
      ).rejects.toThrow(AppError);
    });

    it("should throw error when contact already exists", async () => {
      modelUser.findByEmail.mockResolvedValue({ id: 1, email: "b@b.com" });
      modelContact.findByEmailSenderAndReceiver.mockResolvedValue(true);

      await expect(
        contactService.addContact({ sender: "a@a.com", receiver: "b@b.com" })
      ).rejects.toThrow(AppError);
    });

    it("should return new contact when insert success", async () => {
      modelUser.findByEmail.mockResolvedValue({
        id: 1,
        username: "User B",
        email: "b@b.com"
      });

      modelContact.findByEmailSenderAndReceiver.mockResolvedValue(null);

      modelContact.insert.mockResolvedValue({
        id: 10,
        emailSender: "a@a.com",
        emailReceiver: "b@b.com"
      });

      const result = await contactService.addContact({
        sender: "a@a.com",
        receiver: "b@b.com"
      });

      expect(result).toEqual({
        contact: {
          id: 10,
          sender: "a@a.com",
          receiver: "b@b.com"
        },
        user: {
          id: 1,
          username: "User B",
          email: "b@b.com"
        }
      });
    });
  });

  describe("getContactBySender", () => {

    it("should throw error if no contact found", async () => {
      modelContact.findByEmailSender.mockResolvedValue([]);

      await expect(
        contactService.getContactBySender({ sender: "a@a.com" })
      ).rejects.toThrow(AppError);
    });

    it("should return contacts", async () => {
      modelContact.findByEmailSender.mockResolvedValue([
        { id: 1, emailSender: "a@a.com", emailReceiver: "b@b.com" }
      ]);

      const result = await contactService.getContactBySender({ sender: "a@a.com" });

      expect(result.length).toBe(1);
    });
  });

  describe("getContactByReceiver", () => {

    it("should throw error when empty", async () => {
      modelContact.findByEmailReceiver.mockResolvedValue([]);

      await expect(
        contactService.getContactByReceiver({ receiver: "b@b.com" })
      ).rejects.toThrow(AppError);
    });

    it("should return contact list", async () => {
      modelContact.findByEmailReceiver.mockResolvedValue([
        { id: 99, emailSender: "x@x.com", emailReceiver: "b@b.com" }
      ]);

      const result = await contactService.getContactByReceiver({ receiver: "b@b.com" });

      expect(result.length).toBe(1);
    });
  });

  describe("deleteContactById", () => {

    it("should return error object when contact not found", async () => {
      modelContact.findById.mockResolvedValue(null);

      const result = await contactService.deleteContactById({ id: 100 });

      expect(result).toBeInstanceOf(AppError);
    });

    it("should throw error when delete failed", async () => {
      modelContact.findById.mockResolvedValue({ id: 100 });
      modelContact.deleteById.mockResolvedValue({ deletedCount: 0 });

      await expect(
        contactService.deleteContactById({ id: 100 })
      ).rejects.toThrow(AppError);
    });

    it("should return result on success", async () => {
      modelContact.findById.mockResolvedValue({ id: 100 });
      modelContact.deleteById.mockResolvedValue({ deletedCount: 1 });

      const result = await contactService.deleteContactById({ id: 100 });

      expect(result.deletedCount).toBe(1);
    });
  });
});
