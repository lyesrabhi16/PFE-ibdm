import express, {  } from "express";
import cors from "cors";
import session from "express-session";
import { connectDB } from "#config/db/db";
import { logger } from "#utils";
import { LOGLEVELS } from "#types/logger.types";
import requestLogger from "#middlewares/logger.express";
import SessionConfig from "#config/session/session.config";
import fs from "fs";
import https from "https";
import http from "http";
import env, { EnvSchema } from "#config/env.config";
import { startServer } from "#utils/server.utils";
import { authRoutes, documentationRoutes, notFoundRoutes, userRoutes } from "#routes";
import { pagination } from "#middlewares/pagination.middelware";
import { cors_config } from "#config/cors/cors.config";
import path from "path";
import { pathConstants } from "#config/path/path.config";

logger.log({ level: LOGLEVELS.INFO, message: "Starting server...", label: "Server" });

logger.log({ level: LOGLEVELS.INFO, message: "Loading environment variables...", label: "Environment" });
EnvSchema.parse(process.env);
logger.log({ level: LOGLEVELS.INFO, message: "Environment variables loaded", label: "Environment" });


// Connect to MongoDB
const isDbConnected = await connectDB().catch((error) => {
  logger.log({ level: LOGLEVELS.ERROR, message: "Failed to connect to database", label: "Database", error: error });
  process.exit(1);
});

if (!isDbConnected) {
  logger.log({ level: LOGLEVELS.ERROR, message: "Failed to connect to database", label: "Database" });
  process.exit(1);
}

const httpPORT = env.HTTP_PORT || 8080;
const httpsPORT = env.HTTPS_PORT || 8443;


const app = express();


// Middleware
app.use(cors(cors_config));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(requestLogger);

// force https
//app.use((req, res, next) => forceHttps(req, res, next, { httpsPORT }));

// Configuration de la session
app.use(session(SessionConfig));

app.use(pagination);

// Static files
app.use('/images', express.static(path.join(pathConstants.__dirname, '../../data/images')));

// Routes
app.use("/api/auth", authRoutes);
app.use("/api/users", userRoutes);

app.get("/", (req, res) => {
  res.status(200).json({ message: "IBDM-SERVER" });
});


// documentation
app.use("/api/documentation", documentationRoutes);
app.use("/api/docs", documentationRoutes);


// not found
app.use("*", notFoundRoutes);

// Start server

const httpsOptions = {
  key: fs.readFileSync("./config/certificates/ibdm.key"),
  cert: fs.readFileSync("./config/certificates/ibdm.crt"),
}

const httpServer = http.createServer(app);
const server = https.createServer(httpsOptions, app);

startServer(httpServer, httpPORT, "Server-HTTP");
startServer(server, httpsPORT, "Server-HTTPS");

