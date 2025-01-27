import { z } from "zod";
import dotenv from "dotenv";
import { ALL } from "dns";

dotenv.config();


const EnvSchemaDefinition = z.object({
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
    ALLOWED_ORIGINS: z.array(z.string()).default(["*"]),
});


export const EnvSchema = z.preprocess((val, ctx) => {
    
    if ((val as any)["ALLOWED_ORIGINS"]) {
        try {
            return {
                ...(val as object),
                "ALLOWED_ORIGINS": JSON.parse((val as any)["ALLOWED_ORIGINS"]),
            };
        } catch (error) {
            ctx.addIssue({
                code: z.ZodIssueCode.custom,
                message: "Failed to parse ALLOWED_ORIGINS, must be a valid JSON array",
                path: ["ALLOWED_ORIGINS"],
                fatal: true,
            });
        }
    }
    return val;
}, EnvSchemaDefinition);

export type Env = z.infer<typeof EnvSchema>;

const env = EnvSchema.parse(process.env);


export default env;
