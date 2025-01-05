import * as argon2 from "argon2";

// Comparer les mots de passe
export const comparePassword = async function (plain_text_password:string, hashed_password: string): Promise<boolean> {
  return argon2.verify(hashed_password, plain_text_password);
};