import { NextFunction, Request, Response } from "express";

const loginValidator = (req:Request, res:Response, next:NextFunction) => {
    const { username, password } = req.body;
    
    if (!username || !password) {
        return res.status(400).json({ message: "username and password are required" });
    }
    
    next();
};

export default loginValidator;