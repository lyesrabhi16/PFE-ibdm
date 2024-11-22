import express from "express";
import dotenv from "dotenv";
import cors from "cors";
import { connectDB, connectDB2 } from "#config/db/db";
import { authRoutes } from "#routes";

dotenv.config();

const app = express();

// Middleware
app.use(cors());
app.use(express.json());

// Connect to MongoDB
connectDB();
//connectDB2();
// Routes
app.use("/api/auth", authRoutes);

// Start server
const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
