import jwt from "jsonwebtoken";

export const generateToken = (userId: string) => {
  const secretKey = process.env.JWT_SECRET || "tonsecretkey";
  return jwt.sign({ userId }, secretKey, { expiresIn: "1h" });
};
