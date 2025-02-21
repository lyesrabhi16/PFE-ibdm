import vine_instance from "#config/validation/vine.config";
import { parse_json } from "#utils/server.utils";
import { password_validator } from "#validators/userValidators/schemas/createUser.validator.schema";
import { $Enums } from "@prisma/client";



const UpdateUserSchema = vine_instance.object({
    email: vine_instance.string().email().normalizeEmail().optional(),
    name: vine_instance.string().minLength(4).maxLength(200).optional(),
    password: password_validator.clone().optional(),
    role: vine_instance.enum($Enums.Role).optional(),
    phone_number: vine_instance.string().mobile().optional(),
    superior_ids: vine_instance.array(vine_instance.string()).minLength(1).parse(parse_json).optional(),
})

const UpdateUserValidator = vine_instance.compile(UpdateUserSchema);
export default UpdateUserValidator;


