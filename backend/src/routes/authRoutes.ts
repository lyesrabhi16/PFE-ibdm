import express from "express";
import { loginValidator } from "#validators";
import { loginUser } from "#controllers/authController";
import { isAuthenticated } from "#middlewares/auth";

const router = express.Router();

// POST /api/auth/login 
router.post("/login", loginValidator,loginUser);
// Route protégée - nécessite le middleware isAuthenticated
router.get("/dashboard", isAuthenticated, (req, res) => {
    res.json({ message: "Vous avez accédé à une route protégée !" });
});

export default router;
