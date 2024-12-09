import ThemedPaperProvider from "@/components/ThemedPaperProvider";
import { Stack } from "expo-router";
import { StatusBar } from "expo-status-bar";
import "@/global.css";
import { GestureHandlerRootView } from "react-native-gesture-handler";
import { SafeAreaProvider, SafeAreaView } from "react-native-safe-area-context";
import Notifications from "@/components/toaster/notifications";
import App from "@/app/_app";

export default function RootLayout() {
	return (
		<SafeAreaProvider>
			<GestureHandlerRootView>
				<ThemedPaperProvider>
						<App />
				</ThemedPaperProvider>
			</GestureHandlerRootView>
		</SafeAreaProvider>
	);
}
