import { createUser, deleteUser, deleteUsers, getUser, getUsers, updateUser } from "#controllers/users.controller";
import { isAuthenticated } from "#middlewares/auth";
import { Permissions } from "#middlewares/permissions";
import { UserManagementPermission } from "#middlewares/permissions/UserManagementPermission";
import createUserValidator from "#validators/userValidators/createUser.validator";
import deleteUsersValidator from "#validators/userValidators/deleteUsers.validator";
import updateUserValidator from "#validators/userValidators/updateUser.validator";
import { Router } from "express";

const userRouter = Router();

const permissions = [UserManagementPermission];


userRouter.get('/', isAuthenticated, Permissions(permissions), getUsers);
userRouter.post("/", isAuthenticated, Permissions(permissions), createUserValidator, createUser);
userRouter.delete('/', isAuthenticated, Permissions(permissions), deleteUsersValidator, deleteUsers);
userRouter.get('/:id', isAuthenticated, Permissions(permissions), getUser);
userRouter.put('/:id', isAuthenticated, Permissions(permissions), updateUserValidator, updateUser);
userRouter.delete('/:id', isAuthenticated, Permissions(permissions), deleteUser);
export default userRouter;
