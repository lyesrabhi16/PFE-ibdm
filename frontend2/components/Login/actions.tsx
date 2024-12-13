import { durations } from "@/constants/durations";
import toasts from "@/constants/toasts";
import { deleteAllToastsExceptSome } from "@/utils/utils";
import toast from "react-hot-toast/headless";
import { GestureResponderEvent } from "react-native";
import { MD3Theme } from "react-native-paper";

const signIn = (
	e: GestureResponderEvent,
	InProgress_SignIn: boolean,
	setInProgress_SignIn: CallableFunction,
	theme: MD3Theme
) => {
	if (InProgress_SignIn) {
		toast.dismiss(toasts.Error_SignIn_InProgress.options.id);
		toast.error(
			toasts.Error_SignIn_InProgress.message,
			toasts.Error_SignIn_InProgress.options
		);
		return;
	}

	const loginPromise = new Promise((resolve, reject) => {
		setTimeout(() => {
			deleteAllToastsExceptSome([toasts.SignIn]);

			setInProgress_SignIn(false);
			resolve(toasts.SignIn.options.success);
		}, durations.LONG);
	});

	toast.promise(loginPromise, toasts.SignIn.options);
	setInProgress_SignIn(true);
};

export default {
	signIn,
};
