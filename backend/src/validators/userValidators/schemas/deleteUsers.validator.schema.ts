import vine_instance from "#config/validation/vine.config";
import { LOGLEVELS } from "#types/logger.types";
import { logger } from "#utils";

const parse_json = (v:string) => {
    try{
        return JSON.parse(v);
    }catch(e) {
        logger.log({ level:LOGLEVELS.ERROR, message:"json parse failed: "+v+ " error: "+(e as Error).message, label:"parse_json" })
        return undefined;
    }
} 

const deleteUsersSchema = vine_instance.object({
    userIds: vine_instance.array(vine_instance.string()).minLength(1).parse(parse_json)
})

const DeleteUsersValidator = vine_instance.compile(deleteUsersSchema);

export default DeleteUsersValidator;