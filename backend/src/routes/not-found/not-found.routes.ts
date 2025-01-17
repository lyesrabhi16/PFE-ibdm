import { Request, Response, Router } from "express";

const not_found = (req:Request, res:Response) => {
    res.status(400).json({
        message: "route does not exist: "+req.method+ " "+ req.url
    })
}

const router = Router();

router.all("*", not_found);

export default router;