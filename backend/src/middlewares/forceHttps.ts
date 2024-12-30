import { LOGLEVELS } from "#types/logger.types";
import { logger } from "#utils";
import { NextFunction, Request, Response } from "express";

const forceHttps = (req: Request, res: Response, next: NextFunction, {
    httpsPORT,
}:{
    httpsPORT:number
}) => {
    if(req.protocol === "http") {
      logger.log({
        level: LOGLEVELS.HTTP,
        message: `Redirecting to https://${req.hostname}:${httpsPORT}${req.url}`,
        label: "Server-HTTP",
        host: req.hostname,
        url: `https://${req.hostname}:${httpsPORT}${req.url}`,
      })
      res.redirect(301, `https://${req.hostname}:${httpsPORT}${req.url}`);
    }else{
      next();
    }
}

export default forceHttps;