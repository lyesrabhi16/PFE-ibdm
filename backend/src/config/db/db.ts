import mongoose from "mongoose";
import dotenv from "dotenv";
import { PrismaClient } from "@prisma/client";
import { logger } from "#utils";
import { LOGLEVELS as LOGLEVELS } from "#types/logger.types";
import { level } from "winston";
import { generateHash } from "#utils/generateHash";
import { PrismaClientKnownRequestError } from "@prisma/client/runtime/library";

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
  await db_client.$connect().catch(() => {
    logger.log({ level:LOGLEVELS.ERROR, message: "Prisma Failed to connect to Database", label: "Prisma" });
  });
  logger.log({ level:LOGLEVELS.INFO, message: "Connected to Databases Client Prisma", label: "Prisma" });
  test_addUser(
    "test_lyes@gmail.com",
    "test_lyes",
  );
}

const test_addUser = async (username: string, password: string) => {
  logger.log({ level:LOGLEVELS.DEBUG, message: "Creating user", label: "Prisma", username: username });
  const user =db_client.user.create({
    data: {
      email: username,
      password: await generateHash(password),
    }}).then(user => {
      logger.log({ level:LOGLEVELS.DEBUG, message: "User created", label: "Prisma", user: user });
    }).catch((e) => {
      if (e instanceof PrismaClientKnownRequestError){
        // PRISMA ERROR CODE P2002 : UNIQUE CONSTRAINT FAILED 
        if (e.code === "P2002"){
          if (e.meta?.target === "User_email_key"){
            logger.log({ level:LOGLEVELS.DEBUG, message: "user exists already, skipping...", label: "Prisma", error: e.message });
          }else{
            logger.log({ level:LOGLEVELS.WARN, message: "Failed to create user, UNCAUGHT Unique Constraint Error", label: "Prisma", error: e });

          }
        }else{
          logger.log({ level:LOGLEVELS.WARN, message: "Failed to create user, UNCAUGHT Error", label: "Prisma", error: e });
        }
      }else{
        logger.log({ level:LOGLEVELS.ERROR, message: "Failed to create user, UNKNOWN Error", label: "Prisma", error: e });
      }

    }
  );
};
