import mongoose from "mongoose";

const messageSchema = new mongoose.Schema(
    {
        id           : String,
        message      : String,
        emailSender  : String,
        emailReceiver: String,
        type         : {type: String, default: "text"},
        status       : {type: String, default: "sent"}, //pending, sent, delivered, read
        time         : String,
    },
);

export default mongoose.model("Messages", messageSchema);