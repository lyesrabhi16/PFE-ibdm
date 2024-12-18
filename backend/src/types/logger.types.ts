export enum LOGLEVELS {
    ERROR = "ERROR",
    WARN = "WARN",
    INFO = "INFO",
    HTTP = "HTTP",
    QUERY = "QUERY",
    DEBUG = "DEBUG"
}
export type ranked_levels_type = {
    [key: string]: number;
}
export type colors_of_levels_type = {
    [key: string]: string;
}

