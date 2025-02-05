import { dirname } from "path";
import { fileURLToPath } from "url";


export const pathConstants = {
    __filename: fileURLToPath(import.meta.url),
    __dirname: dirname(fileURLToPath(import.meta.url))
}