import { LOGLEVELS } from "#types/logger.types";
import { logger } from "#utils";
import { errors } from "@vinejs/vine";
import { NextFunction, Request, Response } from "express";
import loginInputValidator from "#validators/authValidators/schemas/loginInputSchema";

const loginValidator = async (req: Request, res: Response, next: NextFunction) => {
    logger.log({ level: LOGLEVELS.DEBUG, label: "LOGIN", message: "loginValidator started" });

    try {
        console.log("Body: ", req.body);
        
        // validate the request body using the loginInput schema validator
        await loginInputValidator.validate(req.body);
        // if no error occurs, proceed
        next();
    }
    catch (error) {
        // check if the error is a validation error
        // if it is, log it and return a 400 error
        // if the error is not a validation error, log it and return a 500 error
        const errorResponse = error instanceof errors.E_VALIDATION_ERROR ? {
            status: 400,
            message: {
                message: "Validation error",
                error: error.messages
            },
            loglevel: LOGLEVELS.WARN,
            logMessage: "loginValidator validation error",
        } : {
            status: 500,
            message: {
                message: "Internal Server error",
                error: (error as Error).message
            },
            loglevel: LOGLEVELS.ERROR,
            logMessage: "loginValidator unknown error",
        };

        logger.log({ level: errorResponse.loglevel, label: "LOGIN", message: errorResponse.logMessage, error: error });
        res.status(errorResponse.status).json(errorResponse.message);
    }

};

export default loginValidator;