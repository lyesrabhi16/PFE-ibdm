import { z } from "zod";
import dotenv from "dotenv";

dotenv.config();

export const EnvSchema = z.object({
    NODE_ENV: z.enum(["development", "production"]),
    HTTP_PORT: z.number( {
        coerce: true,
    }),
    HTTPS_PORT: z.number( {
        coerce: true,
    }),
    JWT_SECRET: z.string(),
    SESSION_SECRET: z.string(),
    DATABASE_URL: z.string(),
});

export type Env = z.infer<typeof EnvSchema>;

const env = EnvSchema.parse(process.env);


export default env;
