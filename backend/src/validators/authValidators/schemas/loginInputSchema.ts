import vine_instance from "#config/validation/vine_config";


const LoginInputSchema = vine_instance.object({
    email: vine_instance.string().email().normalizeEmail(),
    password: vine_instance.string(),    
})

const loginInputValidator = vine_instance.compile(LoginInputSchema);
export default loginInputValidator;


