import vine_instance from "#config/validation/vine.config";


const deleteUsersSchema = vine_instance.object({
    userIds: vine_instance.array(vine_instance.string()).minLength(1).parse((value:any) => {
        if (typeof value === "string") {
            return [value];
        };
        return value;
    })
})

const DeleteUsersValidator = vine_instance.compile(deleteUsersSchema);

export default DeleteUsersValidator;