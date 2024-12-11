import express, { Request, Response } from "express";
import dotenv from "dotenv";
import cors from "cors";
import session from "express-session";
import MongoStore from "connect-mongo";
import { connectDB, connectDB2 } from "#config/db/db";
import { authRoutes } from "#routes";
import { AddressInfo } from "net";
import { logger } from "#utils";
import { LOGLEVELS } from "#types/logger.types";
import requestLogger from "#middlewares/logger.express";

dotenv.config();

const app = express();

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(requestLogger);

// Configuration de la session
app.use(
  session({
    secret: process.env.SESSION_SECRET || "default_ secret_key",
    resave: false,
    saveUninitialized: false,
    store: MongoStore.create({
      mongoUrl: process.env.MONGO_URI,
      collectionName: "sessions",
    }),
    cookie: {
      httpOnly: true,
      secure: process.env.NODE_ENV === "production",
      maxAge: 24 * 60 * 60 * 1000, // 1 jour
    },
  })
);
// Connect to MongoDB
connectDB();
connectDB2();
// Routes
app.use("/api/auth", authRoutes);

// Start server
const PORT = process.env.PORT || 5000;
const server = app.listen(PORT, () => {
  const address = server.address() as AddressInfo;
  const protocol = "protocol" in address ? address.protocol : "http";
  const host = "address" in address && address.address !== "::" ? address.address : "localhost";
  const { port } = address;
  logger.log({ level: LOGLEVELS.INFO , message: `Server running in ${protocol}://${host}:${port}`, label: "Server", host: host, protocol: protocol, port: port, url: `${protocol}://${host}:${port}` });
});
