import mongoose, { Document, Schema } from "mongoose";
import bcryptjs from "bcryptjs";


// Comparer les mots de passe
export const comparePassword = async function (user_pass:string, password: string): Promise<boolean> {
  return bcryptjs.compare(user_pass, password);
};

