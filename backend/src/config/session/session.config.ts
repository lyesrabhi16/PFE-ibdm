import MongoStore from "connect-mongo";
import { SessionOptions } from "express-session";

const SessionConfig:SessionOptions ={
    secret: process.env.SESSION_SECRET!,
    resave: false,
    saveUninitialized: false,
    store: MongoStore.create({
        mongoUrl: process.env.DATABASE_URL,
        collectionName: "sessions",
    }),
    cookie: {
        httpOnly: true,
        secure: process.env.NODE_ENV === "production",
        sameSite: process.env.NODE_ENV === "production"? "strict": undefined,
        maxAge: 24 * 60 * 60 * 1000, // 1 jour
    },
    name: "sid",
}
export default SessionConfig;