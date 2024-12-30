import { SimpleMessagesProvider } from "@vinejs/vine";
import e from "express";

const fields = {
    email: "email",
    password: "password"
}

const vine_message_provider = new SimpleMessagesProvider({
    "required": "Le champ {{field}} est obligatoire",
    "minLength": "Le champ {{field}} doit avoir une longueur minimale de {{limit}} caractères",
    "maxLength": "Le champ {{field}} doit avoir une longueur maximale de {{limit}} caractères",
    "email": "Le champ {{field}} doit être une adresse email valide",
    "password.regex": "Le champ {{field}} doit contenir au moins une lettre majuscule, une lettre minuscule, un chiffre et un caractère spécial",
}, fields);

export default vine_message_provider;