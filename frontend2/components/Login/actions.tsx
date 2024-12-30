import APIClient from "#/api_client/api_client";
import { durations } from "#/constants/durations";
import { useToasts } from "#/hooks/toasts";
import { SignInRequestData } from "#/types";
import { deleteAllToastsExceptSome } from "#/utils/utils";
import { AxiosError } from "axios";
import toast from "react-hot-toast/headless";
import { GestureResponderEvent } from "react-native";
import { MD3Theme } from "react-native-paper";

const signIn = (
	e: GestureResponderEvent,
	InProgress_SignIn: boolean,
	setInProgress_SignIn: CallableFunction,
	theme: MD3Theme,
	toasts: ReturnType<typeof useToasts>,
	data:SignInRequestData
) => {
	
	if (InProgress_SignIn) {
		toast.dismiss(toasts.Error_SignIn_InProgress.options.id);
		toast.error(
			toasts.Error_SignIn_InProgress.message,
			toasts.Error_SignIn_InProgress.options
		);
		return;
	}

	const loginPromise = APIClient.signIn(data, {
		onSuccess: () => {
			setInProgress_SignIn(false);
		},
		onFail: (error:any)=> {
			setInProgress_SignIn(false);
			if(error?.response?.data?.message){
				toast.error(error?.response?.data?.message, toasts.signInFailed.options);
				return;
			}
			toast.error(toasts.signInFailed.message, toasts.signInFailed.options);
		},
	});

	toast.promise(loginPromise, toasts.SignIn.options);
	setInProgress_SignIn(true);
};

export default {
	signIn,
};
