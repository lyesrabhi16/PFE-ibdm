import { LOGLEVELS } from "#types/logger.types";
import { logger } from "#utils";
import UpdateUserValidator from "#validators/userValidators/schemas/updateUser.validator.schema";
import { errors } from "@vinejs/vine";
import { NextFunction, Request, Response } from "express";

const updateUserValidator = async (req:Request, res:Response, next:NextFunction) => {
    try {
        // validate the request body using the updateUser schema validator
        const validated_data = await UpdateUserValidator.validate(req.body);
        // if no error occurs, proceed
        req.body = validated_data;

        next();
    } catch (error) {
        // check if the error is a validation error
        if (error instanceof errors.E_VALIDATION_ERROR) { 
            return res.status(400).json({
                message: error.message,
                errors: error.messages 
            });   
        }

        // if the error is not a validation error, log it and return a 500 error
        logger.log({ level:LOGLEVELS.ERROR, label: "UpdateUserValidator", message: "updateUserValidator unknown error", error: error });
        res.status(500).json({ message: "an unknown error occurred" });
    }
}

export default updateUserValidator;