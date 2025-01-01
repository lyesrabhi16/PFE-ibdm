import express, { Request, Response } from "express";
import cors from "cors";
import session from "express-session";
import { connectDB } from "#config/db/db";
import { authRoutes } from "#routes";
import { logger } from "#utils";
import { LOGLEVELS } from "#types/logger.types";
import requestLogger from "#middlewares/logger.express";
import SessionConfig from "#config/session/session.config";
import fs from "fs";
import https from "https";
import http from "http";
import dotenv from "dotenv";
import env, { EnvSchema } from "#config/env.config";
import forceHttps from "#middlewares/forceHttps";
import { startServer } from "#utils/server.utils";
import swaggerJSDoc from "swagger-jsdoc";
import swaggerUi from "swagger-ui-express";
import path from "path";

logger.log({ level: LOGLEVELS.INFO, message: "Starting server...", label: "Server" });

dotenv.config();
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

// create openapi specification
const openapiSpecification = swaggerJSDoc({
  failOnError: true,
  definition: {
    openapi: "3.0.0",
    info: {
      title: "IBDM API",
      version: "1.0.0",
      description: "API for the IBDM project",
    },
  },
  apis: ["./src/routes/**/*.ts", "./src/routes/**/*.js", "./src/routes/**/*.yaml", "./src/routes/**/*.yml"],
});
// write the openapi specification to a file
fs.writeFileSync("openapi.json", JSON.stringify(openapiSpecification, null, 2));

app.use('/api/documentation', swaggerUi.serve, swaggerUi.setup(openapiSpecification));

// Middleware
app.use(cors(
  {
    credentials: true,
    origin: true,
  }
));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(requestLogger);

// force https
app.use((req, res, next) => forceHttps(req, res, next, { httpsPORT }));

// Configuration de la session
app.use(session(SessionConfig));

// Routes
app.use("/api/auth", authRoutes);


app.get("/", (req, res) => {
  res.status(200).json({ message: "IBDM-SERVER" });
})




// Start server

const httpsOptions = {
  key: fs.readFileSync("./config/certificates/ibdm.key"),
  cert: fs.readFileSync("./config/certificates/ibdm.crt"),
}

const httpServer = http.createServer(app);
const server = https.createServer(httpsOptions, app);

startServer(httpServer, httpPORT, "Server-HTTP");
startServer(server, httpsPORT, "Server-HTTPS");

