import { View, Text } from "react-native";
import React, { useEffect, useState } from "react";
import { SafeAreaView } from "react-native-safe-area-context";
import { SplashScreen, Stack } from "expo-router";
import Container from "#/components/Container";
import Notifications from "#/components/toaster/notifications";
import { StatusBar } from "expo-status-bar";
import { useTheme } from "react-native-paper";
import { useFonts } from "expo-font";
import StartUpLoadingScreen from "#/app/_startup_loading_screen";
import MaterialCommunityIcons from "react-native-vector-icons/MaterialCommunityIcons";
import toast from "react-hot-toast/headless";
import Screens from "#/app/_screens";
import { startup_load_resources } from "#/utils/actions";

const App = () => {
	const theme = useTheme();
	const [Loaded, setLoaded] = useState(false);

	useEffect(() => {
		startup_load_resources(setLoaded);
	}, [Loaded]);

	return (
		<SafeAreaView
			edges={["top", "bottom"]}
			style={{
				width: "100%",
				height: "100%",
				padding: 0,
				margin: 0,
			}}
		>
			{Loaded ? <Screens /> : <StartUpLoadingScreen />}

			<StatusBar
				animated
				translucent
				style="auto"
				backgroundColor={theme.colors.background}
			/>
			<Notifications />
		</SafeAreaView>
	);
};

export default App;
