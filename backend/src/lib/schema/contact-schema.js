import mongoose from "mongoose";

const contactSchema = new mongoose.Schema(
    {
        emailSender: String,
        emailReceiver: String
    },
    {
        toJSON: {
            virtuals: true,
            versionKey: false,
            transform(doc, ret) {
                ret.id = ret._id; 
                delete ret._id; 
            }
        }
  }
);

export default mongoose.model("Contacts", contactSchema);