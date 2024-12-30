import { requestTimeout } from '#/constants/durations';
import { SignInRequestData } from '#/types';
import axios, { Axios, AxiosError, AxiosInstance, AxiosResponse } from 'axios';
export class APIClient {

    private static readonly BASE_URL = "https://10.2.60.9:8443";
    private static readonly SIGN_IN = this.BASE_URL + "/api/auth/login";
    private static readonly DASHBOARD = this.BASE_URL + "/api/auth/dashboard";
    public static axios_instance: AxiosInstance = axios.create({
        baseURL: APIClient.BASE_URL,
        timeout: requestTimeout,
        headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
        },
        withCredentials: true,
    });

    public static async signIn(data: SignInRequestData, options?: { onSuccess: CallableFunction, onFail: CallableFunction }): Promise<AxiosResponse | any> {
        return new Promise<AxiosResponse | void>(async (resolve, reject) => {
            APIClient.axios_instance.post(APIClient.SIGN_IN, data).then((response) => {
                options?.onSuccess(response);
                resolve(response);
            }).catch((error) => {
                options?.onFail(error);
                reject(error);
            });
        });
    }

    public static async getDashboard(options?: { onSuccess: CallableFunction, onFail: CallableFunction }): Promise<any | any> {
        return new Promise<any | void>(async (resolve, reject) => {
            APIClient.axios_instance.get(APIClient.DASHBOARD).then((response) => {
                console.log("111111111111111");
    
                options?.onSuccess(response);
                resolve(response);
            }).catch((error) => {
                console.log("222222222222222");
                console.log(error);
    
                options?.onFail(error);
                reject(error);
            });
        });
    }
}

APIClient.axios_instance.interceptors.request.use((config) => {
    console.log(`[SEND][${config.method}][${config.url}]`, config);
    return config;
}, (error) => {
    console.log(`[SEND][ERROR][${error.config.method}][${error.config.url}]`, error);
    return Promise.reject(error);
});

APIClient.axios_instance.interceptors.response.use((response) => {
    console.log(`[RECV][${response.config.method}][${response.config.url}][${response.status}]`, response);
    return response;
}, (error) => {
    console.log(`[RECV][ERROR][${error?.config?.method}][${error?.config?.url}][${error?.response?.status}]`, error);
    return Promise.reject(error);
});

export default APIClient;