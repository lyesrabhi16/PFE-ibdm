import env from "#config/env.config";
import { logger } from "#utils";
import { CorsOptions } from "cors";

export const cors_config: CorsOptions =
{
    credentials: true,
    origin: (origin, callback) => {
        logger.log(
            {
                level: "info",
                message: "checking origin " + origin,
                label: "CORS",
                origin: origin,
            }
        );
        if (origin === undefined) {
            let allow = false;
            if(env.NODE_ENV === "development") {
                allow = true;
            }
            logger.log(
                {
                    level: "info",
                    message: "origin allowed because NODE_ENV = '"+env.NODE_ENV+"' ",
                    label: "CORS",
                    origin: origin,
                }
            );
            callback(null, allow);
            return;
        }
        // check for wild card
        if (env.ALLOWED_ORIGINS.indexOf("*") !== -1) {
            logger.log(
                {
                    level: "info",
                    message: "origin "+ origin +"  allowed because of wildcard '*' ",
                    label: "CORS",
                    origin: origin,
                }
            );
            callback(null, true);
            return;
        }

        // check for exact match
        if (env.ALLOWED_ORIGINS.indexOf(origin) !== -1) {
            logger.log(
                {
                    level: "info",
                    message: "origin "+ origin +"  allowed because of exact match ",
                    label: "CORS",
                    origin: origin,
                }
            );
            callback(null, origin);
        } else {
            logger.log(
                {
                    level: "warn",
                    message: "origin "+ origin +"  not allowed ",
                    label: "CORS",
                    origin: origin,
                }
            );
            callback(new Error("Not allowed by CORS"));
        }
    },
    methods: ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
};