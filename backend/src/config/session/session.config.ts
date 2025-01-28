import env from "#config/env.config";
import { LOGLEVELS } from "#types/logger.types";
import { logger } from "#utils";
import MongoStore from "connect-mongo";
import { SessionOptions } from "express-session";


const mongo_store = MongoStore.create({
    mongoUrl: env.DATABASE_URL,
    collectionName: "sessions",
});



mongo_store.on("error", (error) => {
    logger.log({ level: LOGLEVELS.ERROR, message: "Failed to connect to MongoDB", label: "Session", error: error });
    process.exit(1); 
});


const SessionConfig:SessionOptions ={
    secret: env.SESSION_SECRET,
    resave: false,
    saveUninitialized: false,
    store: mongo_store,
    cookie: {
        httpOnly: true,
        secure: true,//true
        sameSite: "none",//env.NODE_ENV === "production"? "strict": undefined,
        maxAge: 24 * 60 * 60 * 1000, // 1 jour
    },
    name: "sid",
}
export default SessionConfig;