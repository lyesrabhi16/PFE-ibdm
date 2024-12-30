

export type stringsType = {
    [key: string]: {
        [key: string]: string;
    }
}
export type stringsTranslationsType = {
    [key: string]: {
        [key: string]: {
            [key in languages]: string;
        }
    }
}

export enum languages{
    en = 'en',
    fr = 'fr',
    ar = 'ar',
}

export interface SignInRequestData {
    email: string;
    password: string;
}