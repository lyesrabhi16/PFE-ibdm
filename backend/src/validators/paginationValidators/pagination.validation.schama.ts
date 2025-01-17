import vine_instance from "#config/validation/vine.config";


const PaginationSchema = vine_instance.object({
    perPage: vine_instance.number().min(1).max(200).decimal(0).positive().optional(),
    page: vine_instance.number().min(1).positive().decimal(0).optional(),
})

const PaginationValidator = vine_instance.compile(PaginationSchema);
export default PaginationValidator;


