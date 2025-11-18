import mongoose from "mongoose";

const messageSchema = new mongoose.Schema({
    id      : {type: String},
    from    : {type: String},
    to      : {type: String},
    type    : {type: String},
    isRead  : {type: Boolean},
    time    : {type: String},
});

export default mongoose.model("Messages", messageSchema);