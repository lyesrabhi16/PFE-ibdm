import { NextFunction, Request, Response } from "express";

export const Permissions = (Permissions: CallableFunction[]) => {
    const check_permissions = async (req:Request, res:Response, next:NextFunction) => {
        try {
            let has_permissions = true;
            let _continue = true;
            for (let permission of Permissions){
                if (_continue){
                    await permission(req, res, (b:boolean = true)=>{
                        has_permissions = b;
                        _continue = false;
                    });
                }else{
                    break;
                }
            };
            if(has_permissions){
                next();
            }else{
                return res.json({ message: "Non autorisé." });
            }
        } catch (error) {
            console.error("Erreur dans le middleware Permissions :", error);
            res.status(500).json({ message: "Erreur serveur." });
        }
    };
    return  check_permissions;
}