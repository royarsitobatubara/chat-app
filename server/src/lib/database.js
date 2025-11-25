import mongoose from "mongoose";
import dotenv from "dotenv";
dotenv.config();

async function database() {
  try{
    await mongoose.connect(process.env.DATABASE_URL);
    console.info("Database connected");
  }catch(error){
    console.error(`Database error: ${error}`);
  }
}

export default database;