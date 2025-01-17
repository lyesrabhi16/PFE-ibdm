import vine_instance from "#config/validation/vine.config";
import { $Enums } from "@prisma/client";


export const password_validator = vine_instance.string().minLength(8).maxLength(200).regex(/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$/);

const UpdateUserSchema = vine_instance.object({
    email: vine_instance.string().email().normalizeEmail().optional(),
    name: vine_instance.string().minLength(4).maxLength(200).optional(),
    password: password_validator.clone().optional(),
    role: vine_instance.enum($Enums.Role).optional(),
    phone_number: vine_instance.string().mobile().optional(),
})

const UpdateUserValidator = vine_instance.compile(UpdateUserSchema);
export default UpdateUserValidator;


