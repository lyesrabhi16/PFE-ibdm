import vine_instance from "#config/validation/vine.config";
import { password_regex } from "#utils/constants";
import { parse_json } from "#utils/server.utils";
import { $Enums } from "@prisma/client";


export const password_validator = vine_instance.string().minLength(8).maxLength(200).regex(password_regex);

const CreateUserSchema = vine_instance.object({
    email: vine_instance.string().email().normalizeEmail(),
    name: vine_instance.string().minLength(4).maxLength(200).optional(),
    password: password_validator,
    role: vine_instance.enum($Enums.Role),
    phone_number: vine_instance.string().mobile().optional(),
    superior_ids: vine_instance.array(vine_instance.string()).minLength(1).parse(parse_json).optional(),
})

const CreateUserValidator = vine_instance.compile(CreateUserSchema);
export default CreateUserValidator;


