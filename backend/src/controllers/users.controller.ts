import { db_client } from "#config/db/db";
import { LOGLEVELS } from "#types/logger.types";
import { logger } from "#utils";
import { Request, Response } from "express";

export const getUsers = async (req: Request, res: Response) => {
    const pagination = req.pagination;

    logger.log({
        level:LOGLEVELS.INFO,
        message: "executing getUser with pagination: "+JSON.stringify(pagination),
        label: "getUsers"
    })
    const users = await db_client.ibdm.user.findMany({
        omit: {
            password: true,
        },
        where: {},
        skip: (pagination.page - 1) * pagination.perPage,
        take: pagination.perPage,
    }).catch(e => {
        res.status(500).json(
            {
                message: "an unknown error occured"+ e.message,
            }
        )
    })

    res.status(200).json({
        users: users
    });
}