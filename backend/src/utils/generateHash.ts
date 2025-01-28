import * as argon2 from "argon2";

// Fonction asynchrone pour générer le mot de passe haché
export const generateHash = async (password:string) => {
  return await argon2.hash(password);
};

// for use when testing by executing the file
if (process.argv[1] === import.meta.filename) {
  const password = process.argv[2] || "Hashira.";  
  console.log("Password: ", password);
  
  generateHash(password).then(hash => console.log("Hash: ", hash));  
}
