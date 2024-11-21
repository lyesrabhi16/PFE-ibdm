import mongoose from "mongoose";
import dotenv from "dotenv";
import { PrismaClient } from "@prisma/client";

// Charger les variables d'environnement
dotenv.config();

export const connectDB = async () => {
  try {
    console.log("Connecting to MongoDB...");
    // Connexion à MongoDB
    const conn = await mongoose.connect(process.env.MONGO_URI || "mongodb://localhost:27017/ibdm", {
      connectTimeoutMS: 5000,
    });
    console.log(`MongoDB Connected: ${conn.connection.host}`);
  } catch (error: unknown) { 
    if (error instanceof Error) { 
      console.error(`MongoDB Connection Error: ${error.message}`); 
    } else {
      console.error("An unknown error occurred");
    }
  }
};

export const connectDB2 = async () => {
  console.log("Connecting Databases Client Prisma...");
  const client = new PrismaClient({
    log: ["query","error", "info"],
  });
  const new_user = await client.user.create({
    data: {
      email: "test@gmail.com",
      password: "test",
    },
  });
  const users = await client.user.findMany();
  console.log(users);
}

