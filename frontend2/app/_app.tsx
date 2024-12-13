import { View, Text } from "react-native";
import React, { useEffect, useState } from "react";
import { SafeAreaView } from "react-native-safe-area-context";
import { SplashScreen, Stack } from "expo-router";
import Container from "#/components/Container";
import Notifications from "#/components/toaster/notifications";
import { StatusBar } from "expo-status-bar";
import { useTheme } from "react-native-paper";
import { useFonts } from "expo-font";

const App = () => {
	const theme = useTheme();
	

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
			<Stack
				screenOptions={{
					headerShown: false,
				}}
			>
				<Stack.Screen name="index" />
				<Stack.Screen name="(pages)/(auth)/sign-in" />
				<Stack.Screen name="+not-found" />
			</Stack>

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
