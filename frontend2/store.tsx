import { light_theme } from "#/constants/themes/light_theme";
import { languages, stringsType } from "#/types";
import { buildStrings, getLanguage, setStorageItem } from "#/utils/utils";
import { ThemeBase } from "react-native-paper";
import { create } from "zustand";
import { defaultLanguage } from "#/constants/strings";
type AppStore = {
    // Define the state of the store here
    theme: ThemeBase;
    setTheme: (theme: ThemeBase) => void;
    
    language: languages,
    strings: stringsType,
    setLanguage: (lang: languages) => void,
}

const useAppStore = create<AppStore>((set, get) => ({
    // Initialize the state of the store here
    theme: light_theme,
    setTheme: (theme) => set({ theme }),

    language: defaultLanguage,
    strings: buildStrings(defaultLanguage),
    setLanguage: async (lang) => {
        set({ language: lang, strings: buildStrings(lang) });
        await setStorageItem("language", lang);
    },

}));

export default useAppStore;