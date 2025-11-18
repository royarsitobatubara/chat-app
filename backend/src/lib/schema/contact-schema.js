import mongoose from "mongoose";

const contactSchema = new mongoose.Schema({
    id          : {type: String},
    email_from  : {type: String},
    email_to    : {type: String},
});

export default mongoose.model("Contacts", contactSchema);