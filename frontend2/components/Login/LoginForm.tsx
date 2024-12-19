import React from "react";
import { ScreenTypes } from "#/constants/sizes";
import LoginFormWideScreen from "#/components/Login/LoginFormWideScreen";
import LoginFormSmallScreen from "#/components/Login/LoginFormSmallScreen";
import { useScreenType } from "#/hooks/useScreenType";

const LoginForm = () => {
  const ScreenType = useScreenType();

  return ScreenType > ScreenTypes.sm ? (
    <LoginFormWideScreen />
  ) : (
    <LoginFormSmallScreen />
  );
};

export default LoginForm;
