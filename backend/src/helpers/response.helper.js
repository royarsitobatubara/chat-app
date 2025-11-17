import { response } from "express"

class ResponseHelper {

    /**
     * @param {response} res
     * @param {number} status 
     * @param {String} message
     * @param {Array|Object|null} data
     */
    static success({ res, status = 200, message = "", data = null }) {
        return res.status(status).json({
            success: true,
            message,
            data
        })
    }

    /**
     * @param {response} res
     * @param {number} status 
     * @param {String} message
     * @param {String|Object} error
     */
    static failed({ res, status = 500, message = "", error = "" }) {
        return res.status(status).json({
            success: false,
            message,
            error
        })
    }
}

export default ResponseHelper
