import { LOGLEVELS } from "#types/logger.types";
import { logger } from "#utils";
import CreateUserValidator from "#validators/userValidators/schemas/createUser.validator.schema";
import { errors } from "@vinejs/vine";
import { NextFunction, Request, Response } from "express";

const createUserValidator = async (req:Request, res:Response, next:NextFunction) => {
    try {
        // validate the request body using the updateUser schema validator
        if (req.body.superior_id) {
            if (typeof req.body.superior_id === "string") {
                req.body.superior_ids = [req.body.superior_id];
            }
            else{
                return res.status(400).json({ message: "superior_id must be a string, if you are sending an array use superior_ids instead" });
            }
        }
        console.log("validating: "+ JSON.stringify(req.body, null, 2));
        const validated_data = await CreateUserValidator.validate(req.body);
        console.log("validated: "+validated_data);
        
        // if no error occurs, proceed
        req.body = validated_data;

        next();
    } catch (error) {
        console.log(error);
        
        // check if the error is a validation error
        if (error instanceof errors.E_VALIDATION_ERROR) { 
            return res.status(400).json({
                message: error.message,
                errors: error.messages 
            });   
        }

        // if the error is not a validation error, log it and return a 500 error
        logger.log({ level:LOGLEVELS.ERROR, label: "CreateUserValidator", message: "createUserValidator unknown error", error: error });
        res.status(500).json({ message: "an unknown error occurred" });
    }
}

export default createUserValidator;