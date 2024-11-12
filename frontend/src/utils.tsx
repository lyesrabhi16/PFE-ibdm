import { stringsAll } from "#/static/strings";
import { languages, stringsType } from "#/types";



export const getLanguage = () => {
    let lang = localStorage.getItem('language') as languages;
    if (lang === null) {
        // Set Default language if not set
        const default_lang = Object.values(languages)[0];
        localStorage.setItem("language", default_lang);
        lang = default_lang;
      }
    return lang;
};

export const buildStrings = (lang: languages):stringsType => {
    console.log("building strings...");
    const strings : stringsType = {};
    for (const component in stringsAll) {
        console.log(component);
        strings[component] = {};
        for (const key in stringsAll[component]){
            strings[component][key] = stringsAll[component][key][lang];
        }
    }
    console.log(strings);
    
    return strings;
}