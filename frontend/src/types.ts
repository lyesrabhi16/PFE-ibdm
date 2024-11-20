import { MenuProps } from "antd";
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

export enum languages {
    en = 'en',
    fr = 'fr',
    ar = 'ar',
}


export type LoginFormViewProps = {
    onSubmit: (values: {
        username: string,
        password: string,
        remember: boolean,
    }) => void,
}

export type LoginFormViewOnSubmitHandler = LoginFormViewProps['onSubmit'];

export type LanguageSwitchButtonViewProps = {
    items: {
        key: string;
        value: string;
        label: string;
    }[];
    language: languages; 
    onMenuClick: MenuProps["onClick"]; 
    switchLanguage: () => void;
}

export type LanguageSwitchButtonOnMenuClickHandler = LanguageSwitchButtonViewProps['onMenuClick'];
export type LanguageSwitchButtonSwitchLanguageHandler = LanguageSwitchButtonViewProps['switchLanguage'];