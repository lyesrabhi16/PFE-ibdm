import { LOGLEVELS } from "#types/logger.types";
import { logger } from "#utils";
import { errors } from "@vinejs/vine";
import { NextFunction, Request, Response } from "express";
import loginInputValidator from "#validators/authValidators/schemas/loginInputSchema";

const loginValidator = async (req: Request, res: Response, next: NextFunction) => {
    logger.log({ level: LOGLEVELS.DEBUG, label: "LOGIN", message: "loginValidator started" });

    try {
        // validate the request body using the loginInput schema validator
        await loginInputValidator.validate(req.body);
        // if no error occurs, proceed
        next();
    }
    catch (error) {
        // check if the error is a validation error
        // if it is, log it and return a 400 error
        // if the error is not a validation error, log it and return a 500 error
        const status = error instanceof errors.E_VALIDATION_ERROR ? 400 : 500;
        const loglevel = error instanceof errors.E_VALIDATION_ERROR ? LOGLEVELS.WARN : LOGLEVELS.ERROR;
        const logMessage = error instanceof errors.E_VALIDATION_ERROR ? "loginValidator validation error" : "loginValidator unknown error";
        const message = error instanceof errors.E_VALIDATION_ERROR ? {
            message: "Validation error",
            error: error.messages
        } : {
            message: "Internal Server error",
            error: (error as Error).message
        };
        logger.log({ level: loglevel, label: "LOGIN", message: logMessage, error: error });
        res.status(status).json(message);
    }

};

export default loginValidator;