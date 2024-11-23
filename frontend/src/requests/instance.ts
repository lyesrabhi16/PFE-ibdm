import constants from '#/constants';
import { log } from '#/utils';
import axios, { AxiosResponse, InternalAxiosRequestConfig } from 'axios';

const axios_instance = axios.create({
    baseURL: 'http://localhost:8000/api/',
    timeout: constants.AXIOS_TIMEOUT,
    headers: {
        'Content-Type': 'application/json'
    },
});

axios_instance.interceptors.request.use(
    (config:InternalAxiosRequestConfig) => {
     log(`[SEND] ${config.method} ${config.url}`, config);
     return config;
    }
)

axios_instance.interceptors.response.use(
    (response:AxiosResponse) => {
     log(`[RECEIVE] ${response.config.method} ${response.config.url} ${response.status}`, response);
     return response;
    }
)

export default axios_instance;