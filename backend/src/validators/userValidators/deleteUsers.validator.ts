import DeleteUsersValidator from "#validators/userValidators/schemas/deleteUsers.validator.schema";
import { errors } from "@vinejs/vine";
import { NextFunction, Request, Response } from "express";


const deleteUsersValidator = async (req:Request, res:Response, next:NextFunction)=> {
    try{
        console.log(req.query);
        const validated_data = await DeleteUsersValidator.validate(req.query);
        req.query = validated_data;
        next();

    }catch(e){
        if (e instanceof errors.E_VALIDATION_ERROR){
            return res.status(400).json({
                message: e.message,
                errors: e.messages
            });
        }
        res.status(500).json({
            message: "an unknown error occurred"
        })
    }
}

export default deleteUsersValidator;