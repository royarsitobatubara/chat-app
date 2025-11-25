import jwt from "jsonwebtoken";
import dotenv from "dotenv";
dotenv.config();

const token = ({payload}) => {
    return jwt.sign(
        payload,
        process.env.JWT_SECRET,
        {expiresIn: '60d'}
    );
}
export default token;