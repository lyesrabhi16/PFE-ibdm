import User from '#models/user';
import { generateToken } from '#utils/generateToken';
import { Request, Response } from 'express';

export const loginUser = async (req:Request, res:Response) => {
  const { username, password } = req.body;
  try {
    // Recherche l'utilisateur par son nom d'utilisateur
    const user = await User.findOne({ username });

    // Si l'utilisateur existe et que le mot de passe est correct
    if (user && (await user.comparePassword(password))) {
      // Génération du token JWT
      const token = generateToken(user.id.toString());
      // Réponse avec les informations de l'utilisateur et le token
      return res.status(200).json({
        id: user.id.toString(),  
        username: user.username,
        token: token,
      });
    } else {
      // Si l'utilisateur ou le mot de passe est incorrect
      return res.status(401).json({ message: "Invalid username or password" });
    }
  } catch (error) {
    // Gestion des erreurs serveur
    if (error instanceof Error) {
      return res.status(500).json({ message: "Server error", error: error.message });
    } else {
      return res.status(500).json({ message: "An unexpected error occurred" });
    }
  }
};
