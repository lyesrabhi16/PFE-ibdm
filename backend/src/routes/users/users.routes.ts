import { deleteUser, deleteUsers, getUser, getUsers, updateUser } from "#controllers/users.controller";
import { isAuthenticated } from "#middlewares/auth";
import { Permissions } from "#middlewares/permissions";
import { isAdminPermission } from "#middlewares/permissions/isAdmin";
import deleteUsersValidator from "#validators/userValidators/deleteUsers.validator";
import updateUserValidator from "#validators/userValidators/updateUser.validator";
import { Router } from "express";

const userRouter = Router();

const permissions = [isAdminPermission];


userRouter.get('/', isAuthenticated, Permissions(permissions), getUsers);
userRouter.delete('/', isAuthenticated, Permissions(permissions), deleteUsersValidator, deleteUsers);
userRouter.get('/:id', isAuthenticated, Permissions(permissions), getUser);
userRouter.put('/:id', isAuthenticated, Permissions(permissions), updateUserValidator, updateUser);
userRouter.delete('/:id', isAuthenticated, Permissions(permissions), deleteUser);
export default userRouter;
