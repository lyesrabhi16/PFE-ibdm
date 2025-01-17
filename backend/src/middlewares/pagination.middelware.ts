import { paginationConfig } from "#config/pagination/pagination.config";
import { LOGLEVELS } from "#types/logger.types";
import { logger } from "#utils";
import PaginationValidator from "#validators/paginationValidators/pagination.validation.schama";
import { errors } from "@vinejs/vine";
import { NextFunction, Request, Response } from "express";

export const pagination = async (req: Request, res: Response, next: NextFunction) => {

    let pagination_data = paginationConfig;

    try {
        const validated_data = await PaginationValidator.validate(req.query);
        console.log("pg: "+ JSON.stringify(validated_data));
        
        pagination_data = { ...pagination_data, ...validated_data };


    } catch (e) {
        if (e instanceof errors.E_VALIDATION_ERROR) {
            res.status(400).json({
                message: "invalid pagination input, " + e.message,
                messages: e.messages
            });
            
        }else{

            logger.log({ level: LOGLEVELS.ERROR, label: "PAGINATION", message: "pagination unknown error", error: e });

            res.status(500).json({
                message: "an unkown error occured",
            })
        }


    } finally {

        req.pagination = pagination_data;
        console.log(`pagination: ${req.pagination} ${pagination_data}`);

        next();
    }

};