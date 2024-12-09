import { durations } from "@/constants/durations";
import toast from "react-hot-toast/headless";
import { GestureResponderEvent } from "react-native";
import { ActivityIndicator, Icon, MD3Theme } from "react-native-paper";

const signIn = (
  e: GestureResponderEvent,
  InProgress_SignIn: boolean,
  setInProgress_SignIn: CallableFunction,
  theme: MD3Theme
) => {
  if (InProgress_SignIn) {
    toast.error("Please wait, sign in is in progress...", {
      duration: durations.LONG,
      icon: <ActivityIndicator size={16}/>,
    });
  }
  toast.loading("Please wait...", {
    id: "SignIn",
  });
  setInProgress_SignIn(true);
  setTimeout(() => {
    setInProgress_SignIn(false);
    toast.dismiss("SignIn");
    toast.success("Sign in successful", {
      duration: durations.SHORT,
    });
  }, durations.LONG);
};

export default {
  signIn,
};
