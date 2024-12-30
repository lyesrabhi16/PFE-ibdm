import { durations } from "#/constants/durations";
import { sizes } from "#/constants/sizes";
import { stringsType } from "#/types";
import { ActivityIndicator } from "react-native-paper";


export const useToasts = (strings: stringsType) => {
    return {
        Error_SignIn_InProgress: {
            message: strings.toasts.Error_SignIn_InProgress,
            options: {
                id: "Error_SignIn_InProgress",
                duration: durations.MEDIUM,
                icon: <ActivityIndicator size={sizes.md}/>,
            }
        },
        SignIn: {
            options: {
                id: "SignIn",
                success: strings.toasts.SignIn_successful,
                loading: strings.toasts.please_wait,
                error: strings.toasts.SignIn_failed, 
            }
        },
        signInFailed: {
            message: strings.toasts.error,
            options: {
                id: "signInFailed",
                duration: durations.MEDIUM,
            }
        }
    }
}

export default useToasts;