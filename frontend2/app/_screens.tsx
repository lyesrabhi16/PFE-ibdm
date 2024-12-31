import React from "react";
import { Stack } from "expo-router";

const Screens = () => {
	return (
		<Stack
			screenOptions={{
				headerShown: false,
			}}
		>
			<Stack.Screen name="index" />
			<Stack.Screen name="(pages)/(auth)/sign-in" />
			<Stack.Screen name="+not-found" />
		</Stack>
	);
};

export default Screens;
