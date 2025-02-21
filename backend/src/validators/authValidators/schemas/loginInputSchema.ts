import vine_instance from "#config/validation/vine.config";


const LoginInputSchema = vine_instance.object({
    email: vine_instance.string().email().normalizeEmail(),
    password: vine_instance.string(),
    rememberMe: vine_instance.boolean(),    
})

const loginInputValidator = vine_instance.compile(LoginInputSchema);
export default loginInputValidator;


