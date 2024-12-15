import MongoStore from "connect-mongo";
import { SessionOptions } from "express-session";

const SessionConfig:SessionOptions ={
    secret: process.env.SESSION_SECRET || "default_ secret_key",
    resave: false,
    saveUninitialized: false,
    store: MongoStore.create({
        mongoUrl: process.env.DATABASE_URL,
        collectionName: "sessions",
    }),
    cookie: {
        httpOnly: true,
        secure: process.env.NODE_ENV === "production",
        maxAge: 24 * 60 * 60 * 1000, // 1 jour
    },
}
export default SessionConfig;