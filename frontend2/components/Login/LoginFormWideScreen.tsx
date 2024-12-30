import { GestureResponderEvent, Image, View } from "react-native";
import React, { useEffect, useState } from "react";
import {
	Button,
	Text,
	Card,
	Checkbox,
	Divider,
	useTheme,
	Icon,
	Headline,
} from "react-native-paper";
import { sizes } from "#/constants/sizes";
import CustomTextInput from "#/components/CustomTextInput";
import PasswordTextInput from "#/components/PasswordTextInput";
import actions from "./actions";
import toast from "react-hot-toast/headless";
import useAppStore from "#/store";
import useToasts from "#/hooks/toasts";
import APIClient from "#/api_client/api_client";
import { AxiosError, AxiosResponse } from "axios";

const LoginFormWideScreen = () => {
	const [email, setEmail] = React.useState("");
	const [password, setPassword] = React.useState("");
	const [RememberMe, setRememberMe] = React.useState(true);

	const [InProgress_SignIn, setInProgress_SignIn] = useState(false);
	const { strings } = useAppStore();
	const theme = useTheme();
	const toasts = useToasts(strings);

	const signIn = (e:GestureResponderEvent) => {
		actions.signIn(e,InProgress_SignIn, setInProgress_SignIn, theme, toasts, {
			email,
			password,
		});
	}

	return (
		<>
			<Card
				style={{
					margin: sizes.lg,
					padding: sizes.lg,
					backgroundColor: theme.colors.background,
					display: "flex",
					flexDirection: "column",
					justifyContent: "center",
					alignItems: "center",
					flexWrap: "nowrap",
				}}
			>
				<Image
					source={require("#/assets/icons/logo/logoImageSet/android/drawable-mdpi/logo.png")}
					style={{
						width: 100,
						height: 100,
						margin: "auto",
					}}
				/>
				<Card.Title
					style={{
						margin: "auto",
					}}
					title={strings.login.title}
					leftStyle={{
						width: "20%",
					}}
					rightStyle={{
						display: "flex",
						flexDirection: "row",
						justifyContent: "center",
						alignItems: "center",
					}}
					titleVariant="headlineLarge"
				/>
				<Headline
					style={{
						textAlign: "center",
					}}
				>
					{strings.login.welcome_message}
				</Headline>
				<Text
					style={{
						textAlign: "center",
					}}
				>
					{strings.login.login_message}
				</Text>
				<Divider
					horizontalInset
					style={{
						marginVertical: sizes.md,
					}}
				/>
				<Card.Content>
					<CustomTextInput
						style={{
							marginVertical: sizes.sm,
						}}
						label={strings.login.email}
						value={email}
						onChangeText={(text) => setEmail(text)}
						left_icon="account-circle-outline"
					/>

					<PasswordTextInput password={password} setPassword={setPassword} />
					<View
						style={{
							display: "flex",
							flexDirection: "row",
							justifyContent: "flex-start",
							alignItems: "center",
							marginVertical: sizes.sm,
						}}
					>
						<Checkbox
							status={RememberMe ? "checked" : "unchecked"}
							onPress={() => {
								setRememberMe((r) => !r);
							}}
						/>
						<Text>{strings.login.remember_me}</Text>
					</View>
				</Card.Content>
				<Card.Actions
					style={{
						display: "flex",
						flexDirection: "column",
						justifyContent: "center",
						alignItems: "center",
					}}
				>
					<Button
						style={{
							margin: "auto",
							marginTop: sizes.lg,
							width: "60%",
						}}
						icon={{ source: "login", direction: "ltr" }}
						mode="contained"
						onPress={signIn}
						loading={InProgress_SignIn}
						disabled={InProgress_SignIn}
					>
						{strings.login.login}
					</Button>
					<Button
					style={{
						marginTop: sizes.lg,
						width: "60%",
						minWidth: 180,
						backgroundColor: theme.colors.secondary,
					}}
					mode="contained"
					onPress={() => {
						APIClient.getDashboard().then((res) => {
							console.log("then:", res);
							toast.success("Success");
						}).catch((err) => {
							console.log("catch:", err);
							toast.error("Error:"+ err?.response?.data?.message || "Unknown Error");
						});
					}}
				>
					test
				</Button>
				</Card.Actions>
			</Card>
		</>
	);
};

export default LoginFormWideScreen;
