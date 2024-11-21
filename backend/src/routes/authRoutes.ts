import express from "express";
import { loginValidator } from "#validators";
import { loginUser } from "#controllers/authController";

const router = express.Router();

// POST /api/auth/login
router.post("/login", loginValidator, loginUser);

export default router;
