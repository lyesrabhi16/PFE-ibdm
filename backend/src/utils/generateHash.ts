import * as bcryptjs from "bcryptjs";



// Fonction asynchrone pour générer le mot de passe haché
export const generateHash = async (password:string) => {
  const salt = await bcryptjs.genSalt(10);  
  return await bcryptjs.hash(password, salt);

};

// for use when testing by executing the file
const password = "Hashira.";  
generateHash(password);
