import * as express from "express";

// Déclare un module pour Express
declare global {
  namespace Express {
    // Étend l'interface Request pour inclure 'user'
    interface Request {
      user?: any; 
    }
  }
}
