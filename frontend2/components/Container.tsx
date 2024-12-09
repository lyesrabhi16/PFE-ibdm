import { View, Text, Dimensions } from "react-native";
import React from "react";
import { Surface, SurfaceProps, useTheme } from "react-native-paper";
import { ScrollView } from "react-native-gesture-handler";
type props = {
	children: React.ReactNode[] | React.ReactNode;
} & SurfaceProps;
const Container = (props: props) => {
	const theme = useTheme();
	return (
		<ScrollView style={{
      width: "100%",
      height: "100%",
      padding: 0,
      margin: 0,
    }}>
			<Surface
				mode="flat"
				{...props}
				style={{
					width: Dimensions.get("window").width,
					height: Dimensions.get("window").height,
					backgroundColor: theme.colors.background,
				}}
			>
				{props.children}
			</Surface>
		</ScrollView>
	);
};

export default Container;
