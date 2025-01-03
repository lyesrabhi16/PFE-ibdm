import express from "express";
import { loginValidator } from "#validators";
import { getAuthenticatedUser, loginUser, logoutUser } from "#controllers/authController";
import { isAuthenticated } from "#middlewares/auth";

const router = express.Router();


router.post("/login", loginValidator,loginUser);
// Route protégée - nécessite le middleware isAuthenticated
router.get("/dashboard", isAuthenticated, (req, res) => {
    res.json({ message: "Vous avez accédé à une route protégée !" });
});
router.post("/logout", isAuthenticated, logoutUser);

router.get("/user/me", isAuthenticated, getAuthenticatedUser);
export default router;
