import { db_client } from '#config/db/db';
import { comparePassword } from '#models/user';
import { LOGLEVELS } from '#types/logger.types';
import { logger } from '#utils';
import { generateToken } from '#utils/generateToken';
import { log } from 'console';
import { Request, Response } from 'express';

export const loginUser = async (req: Request, res: Response) => {
  logger.log({ level: LOGLEVELS.DEBUG, label: 'LOGIN', message: 'loginUser started' });
  const { username, password } = req.body;
  try {

    logger.log({ level: LOGLEVELS.DEBUG, label: 'LOGIN', message: `User ${username} is trying to log in` });
    // Recherche l'utilisateur par son nom d'utilisateur
    const user = await db_client.user.findUnique({
      where: {
        email: username
      }
    });
    logger.log({ level: LOGLEVELS.DEBUG, label: 'LOGIN', message: `User ${username} found` });
    logger.log({ level: LOGLEVELS.DEBUG, label: 'LOGIN', message: `User ${username} comparing passwords...` });
    // Si l'utilisateur existe et que le mot de passe est correct
    if (user && (await (comparePassword(password, user.password)))) {
      logger.log({ level: LOGLEVELS.DEBUG, label: 'LOGIN', message: `User ${username} successfully logged in` });
      logger.log({ level: LOGLEVELS.DEBUG, label: 'LOGIN', message: `User ${username} generating token...` });
      // Génération du token JWT
      const token = generateToken(user.id.toString());
      logger.log({ level: LOGLEVELS.DEBUG, label: 'LOGIN', message: `User ${username} token generated` });
      logger.log({ level: LOGLEVELS.INFO, label: 'LOGIN', message: `User ${username} logged in` });
      // Réponse avec les informations de l'utilisateur et le token
      return res.status(200).json({
        id: user.id.toString(),
        username: user.email,
        token: token,
      });
    } else {
      // Si l'utilisateur ou le mot de passe est incorrect
      logger.log({ level: LOGLEVELS.DEBUG, label: 'LOGIN', message: `User ${username} failed to log in`, error: 'Invalid username or password', existing_password: user?.password, provided_password: password });
      return res.status(401).json({ message: "Invalid username or password" });
    }
  } catch (error) {
    logger.log({ level: LOGLEVELS.ERROR, label: 'LOGIN', message: 'loginUser error', error: error });
    // Gestion des erreurs serveur
    if (error instanceof Error) {
      return res.status(500).json({ message: "Server error", error: error.message });
    } else {
      return res.status(500).json({ message: "An unexpected error occurred" });
    }
  }
};
