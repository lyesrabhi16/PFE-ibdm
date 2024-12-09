import { ScreenTypes } from "@/constants/sizes";
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