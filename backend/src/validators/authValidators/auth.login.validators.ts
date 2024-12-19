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
        if (error instanceof errors.E_VALIDATION_ERROR) {
            // if it is, log it and return a 400 error
            logger.log({ level: LOGLEVELS.WARN, label: "LOGIN", message: "loginValidator error", error: error });
            console.log(error);
            
            res.status(400).json({ message: "Validation error", error: error.messages});
            return
        }
        // if the error is not a validation error, log it and return a 500 error
        logger.log({ level: LOGLEVELS.ERROR, label: "LOGIN", message: "loginValidator unknown error", error: error });
    }

};

export default loginValidator;