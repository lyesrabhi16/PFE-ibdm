import { View, Text } from "react-native";
import React from "react";
import { sizes } from "#/constants/sizes";
import { TextInput, TextInputProps } from "react-native-paper";
import { getFillColor } from "#/utils/utils";
import useAppStore from "#/store";

type props = TextInputProps & {
	password: string;
	setPassword: (text: string) => void;
};

const PasswordTextInput = (props: props) => {
	const {strings} = useAppStore();
	const [showPassword, setShowPassword] = React.useState(false);

	return (
		<TextInput
			secureTextEntry={!showPassword}
			mode="outlined"
			label={strings.login.password}
			value={props.password}
			onChangeText={(text) => props.setPassword(text)}
			left={<TextInput.Icon color={getFillColor} icon="lock-outline" />}
			right={
				<TextInput.Icon
					icon={"eye" + (showPassword ? "-off" : "")}
					color={getFillColor}
					onPress={() => setShowPassword(!showPassword)}
				/>
			}
			{...props}
			style={
				{
					marginBottom: sizes.sm,
					...(props.style as object),
				}
			}
		/>
	);
};

export default PasswordTextInput;
