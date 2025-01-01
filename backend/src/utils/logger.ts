import env from '#config/env.config';
import { colors_of_levels_type, LOGLEVELS, ranked_levels_type } from '#types/logger.types';
import { createLogger, format, level, transports } from 'winston';



const colors: colors_of_levels_type = {};
colors[LOGLEVELS.ERROR] = "red";
colors[LOGLEVELS.WARN] = "yellow";
colors[LOGLEVELS.INFO] = "green";
colors[LOGLEVELS.DEBUG] = "blue";
colors[LOGLEVELS.HTTP] = "magenta";
colors[LOGLEVELS.QUERY] = "cyan";


const format_dev = format.combine(
    format.colorize(
        {
            colors:colors,
        }
    ),
    format.timestamp(),
    format.printf(({ level, message, timestamp, label }) => {
        console.log(`${timestamp} ${level} ${label}: ${message}`);
        return `${timestamp} ${level} ${label}: ${message}`;
    }),
    format.prettyPrint(),
);
const format_prod = format.combine(
    format.timestamp(),
    format.json(),
);

const levels_ranked: ranked_levels_type = Object.keys(LOGLEVELS).reduce((acc: ranked_levels_type, level, index) => {
    acc[level] = index;
    return acc;
}, {});


const logger = createLogger({
    levels: levels_ranked,
    format: env.NODE_ENV === 'development' ? format_dev : format_prod,
    transports: [
        new transports.Console(),
        new transports.File({ level: LOGLEVELS.ERROR, format: format_prod, filename: `logs/${LOGLEVELS.ERROR}.log`, }),
        new transports.File({ level: LOGLEVELS.INFO, format: format_prod, filename:  `logs/${LOGLEVELS.INFO}.log`, }),
        new transports.File({ level: LOGLEVELS.WARN, format: format_prod, filename:  `logs/${LOGLEVELS.WARN}.log`, }),
        new transports.File({ level: LOGLEVELS.DEBUG, format: format_prod, filename: `logs/${LOGLEVELS.DEBUG}.log`, }),
        new transports.File({ level: LOGLEVELS.HTTP, format: format_prod, filename:  `logs/${LOGLEVELS.HTTP}.log`, }),
        new transports.File({ level: LOGLEVELS.QUERY, format: format_prod, filename: `logs/${LOGLEVELS.QUERY}.log`, }),
        new transports.File({ format: format_prod, filename: "logs/combined.log", })
    ]
});

export default logger;