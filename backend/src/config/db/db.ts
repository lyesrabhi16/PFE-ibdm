import mongoose from "mongoose";
import dotenv from "dotenv";
import { PrismaClient } from "@prisma/client";
import { logger } from "#utils";
import { LOGLEVELS as LOGLEVELS } from "#types/logger.types";
import { level } from "winston";
import { generateHash } from "#utils/generateHash";
import { PrismaClientKnownRequestError } from "@prisma/client/runtime/library";
import { rejects } from "assert";

// Charger les variables d'environnement
dotenv.config();
export const db_client = new PrismaClient({
  log: [
    {
      emit: "event",
      level: "query",
    },
    {
      emit: "event",
      level: "info",
    },
    {
      emit: "event",
      level: "error",
    },
    {
      emit: "event",
      level: "warn",
    }
  ],
  errorFormat: "pretty",
});

db_client.$on("query", (e) => {
  logger.log({ level:LOGLEVELS.QUERY, message: e.query, label: "Prisma", query: e });
});
db_client.$on("info", (e) => {
  logger.log({ level:LOGLEVELS.INFO, message: e.message, label: "Prisma", info: e });
});
db_client.$on("error", (e) => {
  logger.log({ level:LOGLEVELS.ERROR, message: e.message, label: "Prisma", error: e });
});
db_client.$on("warn", (e) => {
  logger.log({ level:LOGLEVELS.WARN, message: e.message, label: "Prisma", warn: e });
});


export const connectDB = async () => {
  logger.log({ level:LOGLEVELS.INFO, message: "Connecting Databases Client Prisma...", label: "Prisma", url: process.env.DATABASE_URL });
  const isConnected = await new Promise((resolve, reject) => {
    db_client.user.findFirst({}).then(( con )=>{
        resolve(true);
        logger.log({ level:LOGLEVELS.INFO, message: "Connected to Databases Client Prisma", label: "Prisma" });  
      }).catch(() => {
      reject(false);
      logger.log({ level:LOGLEVELS.ERROR, message: "Prisma Failed to connect to Database", label: "Prisma" });
    });
  })
}