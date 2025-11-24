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
    logger.info(`${email} success to sign in`);
    return AppResponse.success({
        res,
        statusCode: 200,
        message: 'Sign in is success',
        data
    })
  } catch (error) {
    logger.error(`signIn: ${error}`);
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
    logger.info(`${email} success to sign up`);
    return AppResponse.success({
        res,
        status: 201,
        message: 'Sign up is success',
        data: data
    });
  } catch (error) {
    logger.error(`signUp: ${error}`);
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
        logger.info(`Search user success`);
        return AppResponse.success({
            res,
            status: 200,
            message: 'User is found',
            data: data
        });
    } catch (error) {
        logger.error(`searchUser: ${error}`);
        return AppResponse.failed({
            res,
            status: error.statusCode,
            message: error.message,
        });
    }
}

/**
 * GET ALL USER 
 */
const getAllUser = async (req, res, next) => {
    try {
        const data = await service.getAllUser();
        logger.info(`Get all user success`);
        return AppResponse.success({
            res,
            status: 200,
            message: 'Update username success',
            data: data
        });
    } catch (error) {
        logger.error(`getAllUser: ${error}`);
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
        logger.info(`Update username success`);
        return AppResponse.success({
            res,
            status: 200,
            message: 'Update username success',
            data: data
        });
    } catch (error) {
        logger.error(`updateUsername: ${error}`);
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
        logger.info(`Update password success`);
        return AppResponse.success({
            res,
            status: 200,
            message: 'Update password success',
            data: data
        });
    } catch (error) {
        logger.error(`updatePassword: ${error}`);
        return AppResponse.failed({
            res,
            status: error.statusCode,
            message: error.message,
        });
    }
}

/**
 * DELETE USER BY ID
 */
const deleteUserById = async(req, res, next) => {
    const {id} = req.params;
    if(!id){
        logger.warn('ID is required');
        return AppResponse.failed({
            res,
            status: 400,
            message: 'id cannot be empty',
        });
    }
    try {
        const data = await service.deleteUserById({id});
        logger.info(`Delete user success`);
        return AppResponse.success({
            res,
            status: 200,
            message: 'Delete user success',
            data: data
        });
    } catch (error) {
        logger.error(`deleteUserById: ${error}`);
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
  getAllUser,
  updateUsername,
  updatePassword,
  deleteUserById
};
