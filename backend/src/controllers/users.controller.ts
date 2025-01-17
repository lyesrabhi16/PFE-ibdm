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
                message: "an unknown error occurred"+ e.message,
            }
        )
    })

    res.status(200).json({
        users: users
    });
}


export const getUser = async (req: Request, res: Response) => {
    const userId = req.params.id;
    logger.log({
        level:LOGLEVELS.INFO,
        message: "executing getUser with id: "+userId,
        label: "getUser"
    })
    const user = await db_client.ibdm.user.findUnique({
        where: {
            id: userId
        },
        omit: {
            password: true,
        }
    }).catch(e => {
        res.status(500).json(
            {
                message: "an unknown error occurred"+ e.message,
            }
        )
    })

    if (!user) {
        res.status(404).json({
            message: "User not found"
        });
    }

    res.status(200).json({
        user: user
    });
};

export const updateUser = async (req: Request, res: Response) => {
    const userId = req.params.id;
    const data = req.body;
    logger.log({
        level:LOGLEVELS.INFO,
        message: "executing updateUser with id: "+userId,
        label: "updateUser"
    })
    const user = await db_client.ibdm.user.update({
        where: {
            id: userId
        },
        data: data
    }).catch(e => {
        res.status(500).json(
            {
                message: "an unknown error occurred"+ e.message,
            }
        )
    })

    res.status(200).json({
        user: user
    });
};

export const deleteUser = async (req: Request, res: Response) => {
    const userId = req.params.id;
    logger.log({
        level:LOGLEVELS.INFO,
        message: "executing deleteUser with id: "+userId,
        label: "deleteUser"
    })
    await db_client.ibdm.user.delete({
        where: {
            id: userId
        }
    }).catch(e => {
        res.status(500).json(
            {
                message: "an unknown error occurred"+ e.message,
            }
        )
    })

    res.status(200).json({
        message: "User deleted"
    });
};

export const deleteUsers = async (req: Request, res: Response) => {
    const { userIds } = req.query;
    logger.log({
        level:LOGLEVELS.INFO,
        message: "executing deleteUsers",
        label: "deleteUsers"
    })
    await db_client.ibdm.user.deleteMany({
        where: {
            id: {
                in: userIds as string[]
            }
        }
    }).catch(e => {
        res.status(500).json(
            {
                message: "an unknown error occurred"+ e.message,
            }
        )
    })

    res.status(200).json({
        message: "Users deleted"
    });
};