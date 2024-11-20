import { constants } from "#/constants";
import { stringsAll } from "#/static/strings";
import { languages, stringsType } from "#/types";



export const getLanguage = () => {
    let lang = localStorage.getItem('language') as languages;
    if (lang === null) {
        // Set Default language if not set
        const default_lang = constants.DEFAULT_LANGUAGE;
        localStorage.setItem("language", default_lang);
        lang = default_lang;
      }
    return lang;
};

export const buildStrings = (lang: languages):stringsType => {
    // Remove this line entirely
    const strings : stringsType = {};
    for (const component in stringsAll) {
        log(component);
        strings[component] = {};
        for (const key in stringsAll[component]){
            strings[component][key] = stringsAll[component][key][lang];
        }
    }
    log(strings);
    
    return strings;
}
// @ts-expect-error to log anything, only in development mode
export const log = (...args) => {
    if (constants.env_mode === 'development') {
        console.log(...args);
        return;
    }
    console.log("log suppressed, env: ", constants.env_mode);
};