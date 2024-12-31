import Toast from "#/components/toaster/toast";
import { sizes } from "#/constants/sizes";
import { Theme } from "#/global";
import { useToaster } from "react-hot-toast/headless";
import { ActivityIndicator, Icon, Surface, useTheme } from "react-native-paper";

const Notifications = () => {
	const theme: Theme = useTheme();
	const { toasts, handlers } = useToaster({
		style: {
			backgroundColor: theme.colors.surfaceVariant,
			color: theme.colors.onPrimary,
		},
		blank: {
			icon: <Icon source={"information"} size={sizes.md} />,
		},
		success: {
			icon: <Icon source={"check"} size={sizes.md} />,
			style: {
				backgroundColor: theme.colors.successContainer,
			},
		},
		loading: {
			icon: <ActivityIndicator size={sizes.md} />,
			style: {
				backgroundColor: theme.colors.primaryContainer,
				color: "black",
			},
		},
		error: {
			icon: <Icon source={"close"} size={sizes.md} />,
			iconTheme: {
				primary: theme.colors.onError,
				secondary: theme.colors.error,
			},
			style: {
				backgroundColor: theme.colors.errorContainer,
				color: "black",
			},
		},
	});
	const { startPause, endPause } = handlers;
	return (
		<Surface
			style={{
				position: "absolute",
				top: 0,
				left: 0,
				right: 0,
			}}
		>
			{toasts.map((t) => (
				<Toast
					key={t.id}
					t={t}
					updateHeight={(height: any) => handlers.updateHeight(t.id, height)}
					offset={handlers.calculateOffset(t, {
						reverseOrder: false,
					})}
				/>
			))}
		</Surface>
	);
};

export default Notifications;
