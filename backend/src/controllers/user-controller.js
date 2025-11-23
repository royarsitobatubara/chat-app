import service from "../services/user-service.js";
import logger from "../helpers/app-logger.js";
import AppResponse from "../helpers/app-response.js";

/**
 * SIGN IN
 */
const signIn = async (req, res, next) => {
    const {email, password} = req.body;
    if (!email || !password){
        return AppResponse.failed({
            res,
            status: 400,
            message: "Field cannot be empty",
        });
    }
  try {
    const data = await service.signIn({ email, password });
    return AppResponse.success({
        res,
        statusCode: 200,
        message: 'Sign in is success',
        data
    })
  } catch (error) {
    logger.error(error);
    return AppResponse.failed({
        res,
        status: error.statusCode,
        message: error.message,
    });
  }
};

/**
 * SIGN UP
 */
const signUp = async (req, res, next) => {
    const {username, email, password} = req.body;
    if (!username || !email || !password){
        return AppResponse.failed({
            res,
            status: 400,
            message: "Field cannot be empty",
        });
    }
  try {
    const data = await service.signUp({ username, email, password });
    return AppResponse.success({
        res,
        status: 201,
        message: 'Sign up is success',
        data: data
    });
  } catch (error) {
    logger.error(error);
    return AppResponse.failed({
        res,
        status: error.statusCode,
        message: error.message,
    });
  }
};

/**
 * SEARCH USER
 */
const searchUser = async (req, res, next) => {
    const keyword = req.query.user;
    if(!keyword){
        return AppResponse.success({
            res,
            status: 200,
            message: 'No data',
            data: []
        });
    }
    try {
        const data = await service.searchUser(keyword);
        return AppResponse.success({
            res,
            status: 200,
            message: 'User is found',
            data: data
        });
    } catch (error) {
        logger.error(error);
        return AppResponse.failed({
            res,
            status: error.statusCode,
            message: error.message,
        });
    }
}

/**
 * UPDATE USERNAME
 */
const updateUsername = async (req, res, next) => {
    const {email, username} = req.body;
    if(!email || !username){
        return AppResponse.failed({
            res,
            status: 400,
            message: 'Email and username is required',
        });
    }
    try {
        const data = await service.updateUsername({email, username});
        return AppResponse.success({
            res,
            status: 200,
            message: 'Update username success',
            data: data
        });
    } catch (error) {
        logger.error(error);
        return AppResponse.failed({
            res,
            status: error.statusCode,
            message: error.message,
        });
    }
}

/**
 * UPDATE PASSWORD
 */
const updatePassword = async (req, res, next) => {
    const {email, passwordOld, passwordNew} = req.body;
    if(!email || !passwordOld || !passwordNew){
        return AppResponse.failed({
            res,
            status: 400,
            message: 'Fields cannot be empty',
        });
    }
    try {
        const data = await service.updatePassword({email, passwordOld, passwordNew});
        return AppResponse.success({
            res,
            status: 200,
            message: 'Update password success',
            data: data
        });
    } catch (error) {
        logger.error(error);
        return AppResponse.failed({
            res,
            status: error.statusCode,
            message: error.message,
        });
    }
}

export default {
  signIn,
  signUp,
  searchUser,
  updateUsername,
  updatePassword
};
