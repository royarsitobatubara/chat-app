import userSchema from "../lib/schema/user-schema.js";

class UserModel {
    static async create({ id, username, email, password }) {
        try {
            const newUser = await userSchema.create({ id, username, email, password });
            return newUser;
        } catch (error) {
            console.error("Gagal membuat user:", error);
            throw error;
        }
    }

    static async getUserByEmail({ email }) {
        try {
            const user = await userSchema.findOne({ email });
            return user;
        } catch (error) {
            console.error("Gagal mengambil user:", error);
            throw error;
        }
    }

    static async getUserByEmailAndPassword({ email, password }) {
        try {
            const user = await userSchema.findOne({ email, password });
            return user;
        } catch (error) {
            console.error("Gagal login:", error);
            throw error;
        }
    }
}

export default UserModel;
