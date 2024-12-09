import { Image, View } from "react-native";
import React, { useEffect, useState } from "react";
import {
  Button,
  Text,
  Card,
  Checkbox,
  Divider,
  useTheme,
  Icon,
} from "react-native-paper";
import { sizes } from "@/constants/sizes";
import CustomTextInput from "@/components/CustomTextInput";
import PasswordTextInput from "@/components/PasswordTextInput";
import actions from "./actions";
import toast from "react-hot-toast/headless";

const LoginFormWideScreen = () => {
  const [email, setEmail] = React.useState("");
  const [password, setPassword] = React.useState("");
  const [RememberMe, setRememberMe] = React.useState(true);

  const [InProgress_SignIn, setInProgress_SignIn] = useState(false);
  useEffect(() => {
    toast("Using Wide Screen Login Form", {
      icon: <Icon source="information"  size={24}/>,
    })
  })
  const theme = useTheme();
  return (
    <>
      <Card
        style={{
          margin: sizes.lg,
          padding: sizes.lg,
          backgroundColor: theme.colors.background,
          display: "flex",
          flexDirection: "column",
          justifyContent: "center",
          alignItems: "center",
          flexWrap: "nowrap",
        }}
      >
        <Image
          source={require("@/assets/images/react-logo.png")}
          style={{
            width: 100,
            height: 100,
            margin: "auto",
          }}
        />
        <Card.Title
          style={{
            margin: "auto",
          }}
          title="Sign In"
          leftStyle={{
            width: "20%",
          }}
          rightStyle={{
            display: "flex",
            flexDirection: "row",
            justifyContent: "center",
            alignItems: "center",
          }}
          titleVariant="headlineLarge"
        />
        <Divider
          horizontalInset
          style={{
            marginVertical: sizes.md,
          }}
        />
        <Card.Content>
          <CustomTextInput
            style={{
              marginVertical: sizes.sm,
            }}
            label="Email"
            value={email}
            onChangeText={(text) => setEmail(text)}
            left_icon="account-circle-outline"
          />

          <PasswordTextInput password={password} setPassword={setPassword} />
          <View
            style={{
              display: "flex",
              flexDirection: "row",
              justifyContent: "flex-start",
              alignItems: "center", 
              marginVertical: sizes.sm,
            }}
          >
            <Checkbox
              status={RememberMe ? "checked" : "unchecked"}
              onPress={() => {
                setRememberMe((r) => !r);
              }}
            />
            <Text>Remember me</Text>
          </View>
        </Card.Content>
        <Card.Actions
          style={{
            display: "flex",
            flexDirection: "row",
            justifyContent: "center",
            alignItems: "center",
          }}
        >
          <Button
            style={{
              margin: "auto",
              marginTop: sizes.lg,
              width: "60%",
            }}
            icon={{ source: "login", direction: "ltr" }}
            mode="contained"
            onPress={(e) =>
              actions.signIn(e, InProgress_SignIn, setInProgress_SignIn, theme)
            }
            loading={InProgress_SignIn}
            disabled={InProgress_SignIn}
          >
            Sign In
          </Button>
        </Card.Actions>
      </Card>
    </>
  );
};

export default LoginFormWideScreen;
