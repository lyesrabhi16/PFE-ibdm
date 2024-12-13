import { View, Image, Dimensions, GestureResponderEvent } from "react-native";
import React, { useEffect, useState } from "react";
import {
	Button,
	Text,
	Checkbox,
	Divider,
	useTheme,
	Surface,
} from "react-native-paper";
import { sizes } from "#/constants/sizes";
import CustomTextInput from "#/components/CustomTextInput";
import PasswordTextInput from "#/components/PasswordTextInput";
import actions from "#/components/Login/actions";

const LoginFormSmallScreen = () => {
	const [email, setEmail] = React.useState("");
	const [password, setPassword] = React.useState("");
	const [RememberMe, setRememberMe] = React.useState(true);
	const [InProgress_SignIn, setInProgress_SignIn] = useState(false);
	const theme = useTheme();

	const signIn = (e: GestureResponderEvent) => {
		actions.signIn(e, InProgress_SignIn, setInProgress_SignIn, theme);
	};

	return (
		<Surface
			mode="flat"
			style={{
				height: "100%",
				width: "100%",
				margin: "auto",
				padding: sizes.lg,
				backgroundColor: theme.colors.background,
				display: "flex",
				flexDirection: "column",
				justifyContent: "center",
				alignItems: "center",
				flexWrap: "nowrap",
			}}
		>
			<Surface
				mode="flat"
				style={{
					backgroundColor: theme.colors.background,
				}}
			>
				<Image
					source={require("#/assets/images/react-logo.png")}
					style={{
						width: 100,
						height: 100,
						marginHorizontal: "auto",
						marginVertical: sizes.sm,
					}}
				/>

				<Text
					style={{
						textAlign: "center",
						fontSize: 30,
						fontWeight: "bold",
					}}
				>
					Sign In
				</Text>
			</Surface>
			<Divider
				horizontalInset
				style={{
					marginVertical: sizes.lg,
				}}
			/>
			<Surface
				mode="flat"
				style={{
					padding: sizes.md,
					backgroundColor: theme.colors.background,
					width: "95%",
				}}
			>
				<CustomTextInput
					style={{
						marginVertical: sizes.sm,
					}}
					label="Email"
					value={email}
					onChangeText={(text) => setEmail(text)}
					left_icon="account-circle-outline"
				/>

				<PasswordTextInput
					style={{
						marginVertical: sizes.sm,
					}}
					password={password}
					setPassword={setPassword}
				/>
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
					<Text>Remember me</Text>
				</View>
			</Surface>
			<Divider
				horizontalInset
				style={{
					marginVertical: sizes.sm,
				}}
			/>
			<View
				style={{
					display: "flex",
					flexDirection: "row",
					justifyContent: "center",
					alignItems: "center",
				}}
			>
				<Button
					style={{
						marginTop: sizes.lg,
						width: "60%",
						minWidth: 150,
					}}
					icon={{ source: "login", direction: "ltr" }}
					mode="contained"
					onPress={signIn}
					loading={InProgress_SignIn}
					disabled={InProgress_SignIn}
				>
					Sign In
				</Button>
			</View>
		</Surface>
	);
};

export default LoginFormSmallScreen;
