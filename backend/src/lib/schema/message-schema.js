import mongoose from "mongoose";

const messageSchema = new mongoose.Schema(
    {
        message : String,
        from    : String,
        to      : String,
        type    : String,
        isRead  : Boolean,
        time    : String,
    },
    {
        toJSON: {
            virtuals: true,
            versionKey: true,
            transform(doc, ret){
                ret.id = ret._id;
                delete ret._id;
            }
        }
    }
);

export default mongoose.model("Messages", messageSchema);