import React from "react";
import Container from "@/components/Container";
import LoginForm from "@/components/Login/LoginForm";
import LanguageSwitchButton from "@/components/LanguageSwitchButton";
import { Surface, useTheme } from "react-native-paper";
import { SafeAreaView } from "react-native-safe-area-context";
import { sizes } from "@/constants/sizes";

const SignIn = () => {
	const theme = useTheme();
	return (
		<Container>
			<Surface
				mode="flat"
				style={{
					padding: 0,
					margin: 0,
					display: "flex",
					alignSelf: "flex-end",
					flexDirection: "row",
					justifyContent: "center",
					alignItems: "center",
					backgroundColor: theme.colors.background,
					width: "auto",
				}}
			>
				<LanguageSwitchButton />
			</Surface>

			<Surface
				mode="flat"
				style={{
					height: "95%",
					display: "flex",
					flexDirection: "column",
					justifyContent: "center",
					alignItems: "center",
					flexWrap: "nowrap",
				}}
			>
				<LoginForm />
			</Surface>
		</Container>
	);
};

export default SignIn;
