import { getUsers } from "#controllers/users.controller";
import { isAuthenticated } from "#middlewares/auth";
import { Router } from "express";

const userRouter = Router();


userRouter.get('/', isAuthenticated, getUsers);

export default userRouter;
