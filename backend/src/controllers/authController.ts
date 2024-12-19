import { PrismaClient } from '@prisma/client';
import { comparePassword } from "#models/user_actions";
import { LOGLEVELS } from "#types/logger.types";
import { logger } from "#utils";
import { Request, Response } from "express";

const db_client = new PrismaClient();

// Fonction de login avec sessions
export const loginUser = async (req: Request, res: Response) => {
  logger.log({ level: LOGLEVELS.DEBUG, label: "LOGIN", message: "loginUser started" });
  logger.log({ level: LOGLEVELS.DEBUG, label: "LOGIN", message: "Request body", body: req.body });
  const { email, password } = req.body;

  try {
    logger.log({ level: LOGLEVELS.DEBUG, label: "LOGIN", message: `User ${email} is trying to log in` });

    // Recherche l'utilisateur par son email
    const user = await db_client.user.findUnique({
      where: { email: email },
    });

    if (!user) {
      logger.log({ level: LOGLEVELS.DEBUG, label: "LOGIN", message: `User ${email} not found` });
      return res.status(401).json({ message: "Invalid username or password" });
    }

    // Comparer les mots de passe
    const isPasswordValid = await comparePassword(password, user.password);
    if (!isPasswordValid) {
      logger.log({ level: LOGLEVELS.DEBUG, label: "LOGIN", message: `Invalid password for user ${email}` });
      return res.status(401).json({ message: "Invalid username or password" });
    }

    logger.log({ level: LOGLEVELS.DEBUG, label: "LOGIN", message: `User ${email} successfully authenticated` });

    // Créer une session utilisateur
    req.session.userId = user.id; // Stocke l'ID de l'utilisateur dans la session
    req.session.isAuthenticated = true;

    logger.log({ level: LOGLEVELS.INFO, label: "LOGIN", message: `Session created for user ${email}` });

    // Répondre avec un message de succèsi
    res.status(200).json({ message: "Login successful" });
  } catch (error) {
    logger.log({ level: LOGLEVELS.ERROR, label: "LOGIN", message: "loginUser error", error: error });

    if (error instanceof Error) {
      return res.status(500).json({ message: "Server error", error: error.message });
    } else {
      return res.status(500).json({ message: "An unexpected error occurred" });
    }
  }
};

export const logoutUser = async (req: Request, res: Response) => {
  req.session.destroy((err) => {
    if (err) {
      console.error("Erreur lors de la déconnexion :", err);
      return res.status(500).json({ message: "Erreur lors de la déconnexion." });
    }
    res.status(200).json({ message: "Déconnexion réussie." });
  });
};