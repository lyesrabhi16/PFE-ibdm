import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import User from '../models/user';

export const loginUser = async (req: any, res: any) => {
  const { username, password } = req.body;

  try {
    // Recherche l'utilisateur dans la base de données par son email
    const user = await User.findOne({ username });
    if (!user) {
      return res.status(400).json({ message: 'Utilisateur non trouvé' });
    }

    // Compare le mot de passe fourni avec celui stocké en base (hashé)
    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).json({ message: 'Mot de passe incorrect' });
    }

    // Génère un token JWT valide pendant 1 heure
    const token = jwt.sign({ userId: user._id }, 'tonsecretkey', { expiresIn: '1h' });

    // Renvoie le token dans la réponse
    res.json({ token });
  } catch (err) {
    res.status(500).json({ message: 'Erreur serveur' });
  }
};
