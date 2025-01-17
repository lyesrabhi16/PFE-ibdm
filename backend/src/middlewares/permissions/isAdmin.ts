import { LOGLEVELS } from "#types/logger.types";
import { logger } from "#utils";
import { $Enums } from "@prisma/client";
import { NextFunction, Request, Response } from "express";

export const isAdminPermission = async (req:Request, res:Response, has_perm: CallableFunction) => {
    logger.log({
        level:LOGLEVELS.INFO,
        message:"checking isAdmin Permission",
        label: "isAdminPermission"
    })
    try {
    
      if (!req.user || req.user.role !== $Enums.Role.ADMIN) {
        has_perm(false);
        return res.status(403).json({ message: "Non autorisé, vous devez être administrateur." });
      }
      has_perm();
    } catch (error) {
      logger.log({
        level: LOGLEVELS.ERROR,
        message: "Erreur dans la permission isAdminPermission",
        label: "IsAdminPermission",
        error: error,
      })
      has_perm(false);
      res.status(500).json({ message: "an unknown error occurred" });
    }
  }