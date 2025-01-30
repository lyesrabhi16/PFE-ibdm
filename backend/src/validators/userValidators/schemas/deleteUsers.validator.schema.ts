import vine_instance from "#config/validation/vine.config";
import { LOGLEVELS } from "#types/logger.types";
import { logger } from "#utils";
import { parse_json } from "#utils/server.utils";


const deleteUsersSchema = vine_instance.object({
    userIds: vine_instance.array(vine_instance.string()).minLength(1).parse(parse_json)
})

const DeleteUsersValidator = vine_instance.compile(deleteUsersSchema);

export default DeleteUsersValidator;