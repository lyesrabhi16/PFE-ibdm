import { LOGLEVELS } from "#types/logger.types";
import { logger } from "#utils";
import { $Enums } from "@prisma/client";
import { NextFunction, Request, Response } from "express";

export const UserManagementPermission = async (req:Request, res:Response, has_perm: CallableFunction) => {
    logger.log({
        level:LOGLEVELS.INFO,
        message:"checking UserManagement Permission role: "+req.user?.role,
        label: "UserManagementPermission"
    })
    try {
      const allowed_roles: Set<$Enums.Role> = new Set([$Enums.Role.ADMIN, $Enums.Role.ADMIN_SYSTEM, $Enums.Role.SUPERVISOR]);
      
      if (!req.user) {
        has_perm(false);
        return res.status(401).json({ message: "Non autorisé, vous devez etre authentifié." });
      }
      
      if (!allowed_roles.has(req.user!.role) ) {
        has_perm(false);
        return res.status(403).json({ message: "Non autorisé, vous devez être administrateur." });
      }
      
      has_perm();
    
    } catch (error) {
      logger.log({
        level: LOGLEVELS.ERROR,
        message: "Erreur dans la permission UserManagementPermission",
        label: "UserManagementPermission",
        error: error,
      })
      has_perm(false);
      res.status(500).json({ message: "an unknown error occurred" });
    }
  }