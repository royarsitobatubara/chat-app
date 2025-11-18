import mongoose from "mongoose";

const userSchema = new mongoose.Schema({
    id          : {type: String},
    username    : {type: String},
    email       : {type: String},
    password    : {type: String},
    photo       : {type: String},
    token       : {type: String}
});

export default mongoose.model("Users", userSchema);