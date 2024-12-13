import { durations } from "@/constants/durations";
import { ActivityIndicator } from "react-native-paper";

export const toasts = {
    Error_SignIn_InProgress: {
      message: "Please wait, sign in is in progress...",
      options: {
        id: "Error_SignIn_InProgress",
        duration: durations.MEDIUM,
        icon: <ActivityIndicator size={16}/>,
      }
    },
    SignIn: {
      options: {
        id: "SignIn",
        success: "Sign in successful",
        loading: "Please wait...",
        error: "Sign in failed",
      }
    }
}

export default toasts;