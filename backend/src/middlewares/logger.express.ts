import { LOGLEVELS } from '#types/logger.types';
import { logger } from '#utils';
import { Request, Response, NextFunction } from 'express';
import winston from 'winston';

// Express middleware to log requests
const requestLogger = (req: Request, res: Response, next: NextFunction) => {
    res.on('finish', () => {
        logger.log({ level: LOGLEVELS.HTTP, label:"REQUEST",message:`${req.method} ${req.url} ${res.statusCode}` });
    })
    next();
};

export default requestLogger;