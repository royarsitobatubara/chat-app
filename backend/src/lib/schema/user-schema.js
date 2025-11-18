import mongoose from "mongoose";

const userSchema = new mongoose.Schema(
  {
    username: String,
    email: String,
    password: String,
    photo: String,
    token: String
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

export default mongoose.model("Users", userSchema);
