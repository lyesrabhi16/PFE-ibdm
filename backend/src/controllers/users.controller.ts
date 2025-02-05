import { db_client } from "#config/db/db";
import env from "#config/env.config";
import { LOGLEVELS } from "#types/logger.types";
import { logger } from "#utils";
import { generateHash } from "#utils/generateHash";
import { $Enums } from "@prisma/client";
import { PrismaClientKnownRequestError } from "@prisma/client/runtime/library";
import { log } from "console";
import { Request, Response } from "express";
import { unlinkSync } from "fs";

export const getUsers = async (req: Request, res: Response) => {
    const pagination = req.pagination;
    
    const user = req.user!;
    
    logger.log({
        level: LOGLEVELS.INFO,
        message: "executing getUser with pagination: " + JSON.stringify(pagination),
        label: "getUsers"
    })
    
    // At top level (ADMIN_SYSTEM)
    // get ADMINs
    // include SUPERVISORS
    // include OPERATEURS
    const isADMIN_SYSTEM = user.role === $Enums.Role.ADMIN_SYSTEM;
    const users = await db_client.ibdm.user.findMany({
        take: pagination.enablePagination ? pagination.perPage : undefined,
        skip: pagination.enablePagination ? (pagination.page - 1) * pagination.perPage : undefined,
        where: isADMIN_SYSTEM ? {} : {
            superiors: {
                some: {
                    superior_id: user.id
                }
            }
        },
        omit: {
            password: true,
        },
        include:{
            _count: true,
            subordinates: { 
                include:{
                    subordinate: {
                        omit:{
                            password: true,
                        },
                        include:{
                            _count: true,
                            subordinates:{
                                include:{
                                    subordinate:{
                                        omit:{
                                            password: true,
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    });
    
    const nbrTotalUsers = await db_client.ibdm.user.count({
        where: isADMIN_SYSTEM ? {} : {
            superiors: {
                some: {
                    superior_id: user.id
                }
            }
        }
    });
    const nbrTotalPages = Math.ceil(nbrTotalUsers / pagination.perPage);

    res.status(200).json({
        users: users,
        nbrTotalUsers: nbrTotalUsers,
        nbrTotalPages: pagination.enablePagination ? nbrTotalPages : undefined,
        currentPage: pagination.enablePagination ? pagination.page : undefined,
        perPage: pagination.enablePagination ? pagination.perPage : undefined,
    });
}


export const getUser = async (req: Request, res: Response) => {
    const userId = req.params.id;
    logger.log({
        level: LOGLEVELS.INFO,
        message: "executing getUser with id: " + userId,
        label: "getUser"
    })
    const user = await db_client.ibdm.user.findUnique({
        where: {
            id: userId
        },
        include: {
            superiors: true,
            subordinates: {
                include: {
                    subordinate: {
                        omit: {
                            password: true,
                        },
                        include:{
                            _count: true,
                            subordinates:{
                                include:{
                                    subordinate:{
                                        omit:{
                                            password: true,
                                        }
                                    }
                                }
                        }  }
                    }
                }
            },
            _count:true,
        },
        omit: {
            password: true,
        }
    }).catch(e => {
        res.status(500).json(
            {
                message: "an unknown error occurred" + e.message,
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
        level: LOGLEVELS.INFO,
        message: "executing updateUser with id: " + userId,
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
                message: "an unknown error occurred" + e.message,
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
        level: LOGLEVELS.INFO,
        message: "executing deleteUser with id: " + userId,
        label: "deleteUser"
    })
    await db_client.ibdm.user.delete({
        where: {
            id: userId
        }
    }).catch(e => {
        res.status(500).json(
            {
                message: "an unknown error occurred" + e.message,
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
        level: LOGLEVELS.INFO,
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
                message: "an unknown error occurred" + e.message,
            }
        )
    })

    res.status(200).json({
        message: "Users deleted"
    });
};

export const createUser = async (req: Request, res: Response) => {
    try {
        const {
            email,
            name,
            phone_number,
            role,
            password,
            superior_ids,
        } = req.body;
        logger.log({
            level: LOGLEVELS.DEBUG,
            message: "started",
            label: "createUser",
        });
        logger.log({
            level: LOGLEVELS.DEBUG,
            message: "generating hash",
            label: "createUser",
        });
        // hash password
        const hashed = await generateHash(password)
        logger.log({
            level: LOGLEVELS.DEBUG,
            message: "hash generated",
            label: "createUser",
        });
        if (!hashed) return;

        logger.log({
            level: LOGLEVELS.DEBUG,
            message: "creating user",
            label: "createUser",
        });

        // if there is a superior_id check that it exists
        if (superior_ids) {
            superior_ids.forEach((id:string) => {
                db_client.ibdm.user.findUniqueOrThrow({
                    where: {
                        id: id
                    }
                })
                
            });
            
        }

        

        const user = await db_client.ibdm.user.create({
            data: {
                email: email,
                password: hashed,
                name: name,
                role: role,
                phone_number: phone_number,
                avatar_url: req.file ? env.BASE_URL+"/images/avatar/"+req.file.filename: "",
                superiors: superior_ids ? {
                    createMany: {
                        data: superior_ids.map((id:string) => {
                            return {
                                superior_id: id
                            }
                        })
                    }
                } : undefined,
            },
            omit: {
                password: true,
            }
        })

        logger.log({
            level: LOGLEVELS.DEBUG,
            message: "user created" + req.file ? ` with avatar '${req.file?.filename}'` : "",
            label: "createUser",
        });
        

        res.status(201).json({
            message: "user created successfully",
            user: user,
        })
    } catch (e) {
        // remove saved file on error
        if (req.file) {
             unlinkSync(req.file.path);
        }

        if (e instanceof PrismaClientKnownRequestError) {
            logger.log({
                level: LOGLEVELS.ERROR,
                message: `error code: ${e.code}`,
                error: e,
                label: "createUser",
            });

            if (e.code === "P2002") {
                return res.status(400).json({
                    message: "email already exists",
                })
                
            }

            if(e.code === "P2025") {
                return res.status(400).json({
                    message: "superior does not exist",
                })
            }

        }
        
        logger.log({
            level: LOGLEVELS.ERROR,
            message: "an unknown error occurred while creating user: "+(e as Error).message,
            error: e,
            label: "createUser",
        });

        res.status(500).json({
            message: "an unknown error occurred while creating user",
        })
    }

};