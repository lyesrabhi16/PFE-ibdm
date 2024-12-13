import React from 'react'
import { ActivityIndicator, Surface, Text } from 'react-native-paper'
import { sizes } from '#/constants/sizes'
import Container from '#/components/Container'
import { Image } from 'react-native'

const StartUpLoadingScreen = () => {
  const loading_image = require("#/assets/icons/logo/logoImageSet/android/drawable-hdpi/logo.png");
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
      <Text>Loading...</Text>
      <ActivityIndicator style={{
        margin: sizes.lg
      }} size={sizes.xl} />
    </Surface>
  )
}

export default StartUpLoadingScreen