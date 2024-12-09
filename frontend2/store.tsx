import { ThemeBase } from "react-native-paper";
import { create } from "zustand";

type AppStore = {
    // Define the state of the store here
    theme: ThemeBase | undefined;
    setTheme: (theme: ThemeBase) => void;
}

const useAppStore = create<AppStore>((set, get) => ({
    // Initialize the state of the store here
    theme: undefined,
    setTheme: (theme: ThemeBase) => set({ theme }),
}));

export default useAppStore;