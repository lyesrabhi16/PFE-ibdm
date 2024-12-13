import ThemedPaperProvider from "#/components/ThemedPaperProvider";
import "#/global.css";
import { GestureHandlerRootView } from "react-native-gesture-handler";
import { SafeAreaProvider, SafeAreaView } from "react-native-safe-area-context";
import App from "#/app/_app";
import { useEffect } from "react";
import { getLanguage } from "#/utils/utils";
import useAppStore from "#/store";

export default function RootLayout() {
	const { setLanguage } = useAppStore();
	useEffect(() => {
		getLanguage().then((lang) => {
			setLanguage(lang);
		});
	}, []);
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
