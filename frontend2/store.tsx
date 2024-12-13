import { light_theme } from "#/constants/themes/light_theme";
import { ThemeBase } from "react-native-paper";
import { create } from "zustand";

type AppStore = {
    // Define the state of the store here
    theme: ThemeBase;
    setTheme: (theme: ThemeBase) => void;
    
    strings: {
        [key: string]: string;
    },
    setStrings: (strings: { [key: string]: string }) => void;
}

const useAppStore = create<AppStore>((set, get) => ({
    // Initialize the state of the store here
    theme: light_theme,
    setTheme: (theme) => set({ theme }),

    strings: {},
    setStrings: (strings) => set({ strings }),
}));

export default useAppStore;