import { response } from "express"

class AppResponse {

    /**
     * @param {response} res
     * @param {number} status 
     * @param {String} message
     * @param {Array|Object|null} data
     */
    static success({ res, statusCode = 200, message = "success", data = null }) {
        return res.status(statusCode).json({
            success: true,
            statusCode,
            message,
            data,
            timestamp: new Date().toISOString()
        });
    }

    /**
     * @param {response} res
     * @param {number} status 
     * @param {String} message
     * @param {String|Object} error
     */
    static failed({ res, statusCode = 500, message = "Internal server error", error = null }) {
        return res.status(statusCode).json({
            success: false,
            statusCode,
            message,
            error,
            timestamp: new Date().toISOString()
        });
    }

    /**
     * 
     * @param {String} id 
     * @param {String} message 
     * @param {String} emailSender 
     * @param {String} emailReceiver 
     * @param {String} type 
     * @param {String} status 
     * @param {String} time 
     */
    static message(id, message, emailSender, emailReceiver, type, status, time){
        return {
            id,
            message,
            emailSender,
            emailReceiver,
            type,
            status,
            time
        };
    }

    /**
     * 
     * @param {String} id 
     * @param {String} status 
     */
    static messageStatus(id, status){
        return {
            id,
            status
        }
    }
}

export default AppResponse;
