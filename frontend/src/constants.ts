import { languages } from "#/types";

export const BASE_URL = "http://localhost:8000";

export const constants = {
    env_mode: "development", // development | production

    /* API base url */
    BASE_URL: BASE_URL,

    /* API endpoints  */
    LOGIN_URL: BASE_URL+"/api/login",

    /* OPTIONS */
    MESSAGE_DURATIONS: {
        // in seconds
        short: 1,
        long: 3,
        indefinite: 0,
    },
    AXIOS_TIMEOUT: 2000,
    DEFAULT_LANGUAGE: "en" as languages,

}

export default constants;

