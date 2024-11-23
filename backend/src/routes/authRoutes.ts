import { loginUser } from "#controllers/authController";
import User from "#models/user";
import { generateToken } from "#utils/generateToken";
import { loginValidator } from "#validators";
import express from "express";

const router = express.Router();

// POST /api/auth/login
router.post("/login", loginValidator, loginUser);

export default router;
