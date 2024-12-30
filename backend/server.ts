import express, { Request, Response } from "express";
import dotenv from "dotenv";
import cors from "cors";
import session from "express-session";
import MongoStore from "connect-mongo";
import { connectDB } from "#config/db/db";
import { authRoutes } from "#routes";
import { AddressInfo } from "net";
import { logger } from "#utils";
import { LOGLEVELS } from "#types/logger.types";
import requestLogger from "#middlewares/logger.express";
import SessionConfig from "#config/session/session.config";
import fs from "fs";
import https from "https";
import http from "http";


dotenv.config();

const app = express();

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

// Configuration de la session
app.use(session(SessionConfig));
// Connect to MongoDB
connectDB();
// Routes
app.use("/api/auth", authRoutes);


app.get("/",(req, res) => {
  res.status(200).json({ message: "IBDM-SERVER" });
})



// Start server
const httpPORT = 8080;
const httpsPORT = 8443;


const httpsOptions = {
  key: fs.readFileSync("./config/certificates/ibdm.key"),
  cert: fs.readFileSync("./config/certificates/ibdm.crt"),
}
const httpServer = http.createServer(app).listen(httpPORT);
const server = https.createServer(httpsOptions, app);
server.listen(httpsPORT, () => {
  const address = server.address() as AddressInfo;
  const protocol = "protocol" in address ? address.protocol : "http";
  const host = "address" in address && address.address !== "::" ? address.address : "localhost";
  const { port } = address;
  logger.log({ level: LOGLEVELS.INFO, message: `Server running in ${protocol}://${host}:${port}`, label: "Server", host: host, protocol: protocol, port: port, url: `${protocol}://${host}:${port}` });
});