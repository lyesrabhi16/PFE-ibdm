import constants from "#/constants";
import { axios_instance } from "#/requests";

export const Request_Login = async (username: string, password: string, remember: boolean) => {
    return await axios_instance.post(constants.LOGIN_URL, {
        username: username,
        password: password,
        remember: remember,
    });
}