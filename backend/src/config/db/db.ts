import dotenv from "dotenv";
import { PrismaClient } from "@prisma/client";
import { logger } from "#utils";
import { LOGLEVELS as LOGLEVELS } from "#types/logger.types";
import env from "#config/env.config";
import  { PrismaClient as automateClient } from "#models/automates_db/generated/automateClient";

// Charger les variables d'environnement
dotenv.config();



export const db_client = {
  automate: new automateClient({
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
  }),
  ibdm: new PrismaClient({
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
  })
};
for (let db in db_client) {
  (db_client as any)[db].$on("query", (e) => {
    logger.log({ level:LOGLEVELS.QUERY, message: e.query, label: "Prisma-"+db, query: e });
  });
  (db_client as any)[db].$on("info", (e) => {
    logger.log({ level:LOGLEVELS.INFO, message: e.message, label: "Prisma-"+db, info: e });
  });
  (db_client as any)[db].$on("error", (e) => {
    logger.log({ level:LOGLEVELS.ERROR, message: e.message, label: "Prisma-"+db, error: e });
  });
  (db_client as any)[db].$on("warn", (e) => {
    logger.log({ level:LOGLEVELS.WARN, message: e.message, label: "Prisma-"+db, warn: e });
  });
}



export const connectDB = async () => {
  logger.log({ level:LOGLEVELS.INFO, message: "Connecting Databases Client Prisma...", label: "Prisma", url: env.DATABASE_URL });

  return new Promise(async (resolve, reject) => {
    let failed = false;


      const result_ibdm = await db_client.ibdm.user.findFirst({}).catch(() => {
        logger.log({ level:LOGLEVELS.ERROR, message: "Failed to connect to Database ibdm", label: "Prisma-ibdm"});
        failed = true;
      });

      const result_automate = await db_client.automate.test_table.findFirst({}).catch(() => {
        logger.log({ level:LOGLEVELS.ERROR, message: "Failed to connect to Database automate", label: "Prisma-automate"});
        failed = true;
      });
        
    if (!failed) {
      logger.log({ level:LOGLEVELS.INFO, message: "Connected to Databases", label: "Prisma" });
      resolve(true);
    } else {
      logger.log({ level:LOGLEVELS.ERROR, message: "Failed to connect to Database(s)", label: "Prisma" });
      reject(false);
    }
  });
}