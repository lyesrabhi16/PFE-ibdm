import { SplashScreen } from "expo-router";
import toast from "react-hot-toast/headless";
import MaterialCommunityIcons from "react-native-vector-icons/MaterialCommunityIcons";

export const startup_load_resources = async (
	setLoaded: CallableFunction
) => {
	await SplashScreen.preventAutoHideAsync();
	MaterialCommunityIcons.loadFont()
		.then(() => {
			SplashScreen.hideAsync();
			setLoaded(true);
			//toast.success("Fonts loaded successfully.");
		})
		.catch(() => {
			SplashScreen.hideAsync();
			setLoaded(true);
			toast.error(
				"Failed to load fonts, this may cause some icons to not display properly."
			);
		});
};
