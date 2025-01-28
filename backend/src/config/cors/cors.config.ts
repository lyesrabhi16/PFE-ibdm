import env from "#config/env.config";
import { CorsOptions } from "cors";

export const cors_config: CorsOptions =
{
    credentials: true,
    origin: (origin, callback) => {

        if (origin === undefined) {
            let allow = false;
            if(env.NODE_ENV === "development") {
                allow = true;
            }
            callback(null, allow);
            return;
        }
        // check for wild card
        if (env.ALLOWED_ORIGINS.indexOf("*") !== -1) {
            callback(null, true);
            return;
        }

        // check for exact match
        if (env.ALLOWED_ORIGINS.indexOf(origin) !== -1) {
            callback(null, origin);
        } else {
            callback(new Error("Not allowed by CORS"));
        }
    },
    methods: ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
};