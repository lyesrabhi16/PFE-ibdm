import { db_client } from "#config/db/db";
import { LOGLEVELS } from "#types/logger.types";
import { logger } from "#utils";
import { $Enums } from "@prisma/client";
import { Request, Response, NextFunction } from "express";

// Middleware pour vérifier si l'utilisateur est connecté avec une session
export const isAuthenticated = async (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  logger.log({level:LOGLEVELS.INFO, message:"checking isAuthenticated Permission", label: "isAuthenticated"})
  try {
    // Vérifie si la session contient un ID utilisateur
    if (!req.session || !req.session.userId) {
      return res.status(401).json({ message: "Non autorisé, veuillez vous connecter." });
    }

    // Récupère l'utilisateur à partir de l'ID stocké dans la session
    const user = await db_client.ibdm.user.findUnique({
      where: { id: req.session.userId, },
      omit: {

        password: true,
      },
      
    });
    if (!user) {
      return res.status(404).json({ message: "Utilisateur non trouvé." });
    }

    // Ajoute l'utilisateur à l'objet `req` pour un accès ultérieur dans les routes
    req.user = user;
    next();
  } catch (error) {
    console.error("Erreur dans le middleware isAuthenticated :", error);
    res.status(500).json({ message: "Erreur serveur." });
  }
};
