import { dark_theme } from "@/constants/themes/dark_theme";
import { light_theme } from "@/constants/themes/light_theme";
import { Appearance } from "react-native";

export const getSystemTheme = () => {
    const colorScheme = Appearance.getColorScheme();
    return colorScheme === "dark" ? dark_theme : light_theme;
};