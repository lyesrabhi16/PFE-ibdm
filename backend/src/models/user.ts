import mongoose, { Document, Schema } from "mongoose";
import bcryptjs from "bcryptjs";

interface IUser extends Document {
  username: string;
  password: string;
  comparePassword(password: string): Promise<boolean>;
}

// Définir le schéma de l'utilisateur
const userSchema = new Schema<IUser>({
  username: { type: String, required: true, unique: true },
  password: { type: String, required: true },
});

// Comparer les mots de passe
export const comparePassword = async function (user_pass:string, password: string): Promise<boolean> {
  return bcryptjs.compare(user_pass, password);
};

// Hasher le mot de passe avant de l'enregistrer
userSchema.pre("save", async function (next) {
  if (!this.isModified("password")) return next();
  this.password = await bcryptjs.hash(this.password, 10);
  next();
});

const User = mongoose.model<IUser>("User", userSchema);

export default User;
