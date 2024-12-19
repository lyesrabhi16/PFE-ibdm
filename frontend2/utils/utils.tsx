import { ScreenTypes } from "#/constants/sizes";
import { stringsAll } from "#/constants/strings";
import toasts from "#/hooks/toasts";
import { languages, stringsType } from "#/types";
import AsyncStorage from "@react-native-async-storage/async-storage";
import toast from "react-hot-toast/headless";
import { Dimensions } from "react-native";
import { useTheme } from "react-native-paper";
export const getFillColor = (focused:boolean) => {
    const theme = useTheme();
    return focused ? theme.colors.primary : theme.colors.onSurface;
}

export const getScreenType = () => {
    const window_width = Dimensions.get('window').width;
    if (window_width < 768) {
        return ScreenTypes.sm;
    } else if (window_width < 1024) {
        return ScreenTypes.md;
    } else {
        return ScreenTypes.lg;
    }
}

export const deleteAllToastsExceptSome = (toasts_to_keep: any[]) => {
    Object.values(toasts).forEach((toast_config) => {
        if (toasts_to_keep.find((toast) => toast.options.id === toast_config.options.id)){
            return;
        }
        toast.dismiss(toast_config.options.id);
    });
}


export const getLanguage = async () => {
    let lang =  await getStorageItem("language") as languages;
    if (lang === null) {
        // Set Default language if not set
        const default_lang = Object.values(languages)[0];
        setStorageItem("language", default_lang);
        lang = default_lang;
      }
    return lang;
};

export const buildStrings = (lang: languages):stringsType => {
    // Remove this line entirely
    const strings : stringsType = {};
    for (const component in stringsAll) {
        strings[component] = {};
        for (const key in stringsAll[component]){
            strings[component][key] = stringsAll[component][key][lang];
        }
    }
    console.log(strings);

    return strings;
}

export const getStorageItem = async (key: string) => {
    return await AsyncStorage.getItem(key);
}

export const setStorageItem = async (key: string, value: string) => {
    return await AsyncStorage.setItem(key, value);
}