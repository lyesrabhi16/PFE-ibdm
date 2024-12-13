import { ScreenTypes } from "@/constants/sizes";
import toasts from "@/constants/toasts";
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