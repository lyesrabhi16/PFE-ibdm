import React from 'react'
import { ActivityIndicator, Surface, Text } from 'react-native-paper'
import { sizes } from '#/constants/sizes'
import Container from '#/components/Container'
import { Image } from 'react-native'
import useAppStore from '#/store'

const StartUpLoadingScreen = () => {
  const loading_image = require("#/assets/icons/logo/logoImageSet/android/drawable-hdpi/logo.png");
  const { strings } = useAppStore();
  return (
    <Surface mode='flat' style={
        {
            display: "flex",
            flexDirection: "column",
            justifyContent: "center",
            alignItems: "center",
            height: "100%",
            width: "100%",
        }
    }>
      <Image source={loading_image} />
      <Text>{strings.startup.loading}</Text>
      <ActivityIndicator style={{
        margin: sizes.lg
      }} size={sizes.xl} />
    </Surface>
  )
}

export default StartUpLoadingScreen