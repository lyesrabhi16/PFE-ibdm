import { LOGLEVELS } from "#types/logger.types";
import { logger } from "#utils";
import { NextFunction, Request, Response } from "express";

const loginValidator = (req:Request, res:Response, next:NextFunction) => {
    const { email, password } = req.body;
    logger.log({ level: LOGLEVELS.DEBUG, label: "LOGIN", message: "loginValidator started" });
    if (!email || !password) {
        return res.status(400).json({ message: "email and password are required" });
    }
    
    next();
};

export default loginValidator;