import * as bcryptjs from "bcryptjs";


const password = "Hashira.";  

// Fonction asynchrone pour générer le mot de passe haché
const generateHash = async () => {
  const salt = await bcryptjs.genSalt(10);  
  const hashedPassword = await bcryptjs.hash(password, salt);  
  console.log(hashedPassword);  
};

generateHash();
