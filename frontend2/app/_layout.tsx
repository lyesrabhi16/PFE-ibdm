import ThemedPaperProvider from "#/components/ThemedPaperProvider";
import "#/global.css";
import { GestureHandlerRootView } from "react-native-gesture-handler";
import { SafeAreaProvider, SafeAreaView } from "react-native-safe-area-context";
import App from "#/app/_app";

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
