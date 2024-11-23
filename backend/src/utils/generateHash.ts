import * as bcryptjs from "bcryptjs";


const password = "Hashira.";  

// Fonction asynchrone pour générer le mot de passe haché
export const generateHash = async (password:string) => {
  const salt = await bcryptjs.genSalt(10);  
  const hashedPassword = await bcryptjs.hash(password, salt);  
  console.log(hashedPassword);  
  return hashedPassword;
};

generateHash(password);
