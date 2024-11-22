import mongoose from "mongoose";
import dotenv from "dotenv";

// Charger les variables d'environnement
dotenv.config();

const connectDB = async () => {
  try {
    // Connexion à MongoDB
    const conn = await mongoose.connect(process.env.MONGO_URI || "mongodb://localhost:27017/mydb", {
    });
    console.log(`MongoDB connected: ${conn.connection.host}`);
  } catch (error: unknown) { 
    if (error instanceof Error) { 
      console.error(`Error: ${error.message}`); 
    } else {
      console.error("An unknown error occurred");
    }
    process.exit(1);
  }
};

export default connectDB;
