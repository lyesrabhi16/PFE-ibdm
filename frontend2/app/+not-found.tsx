import { View, Text } from 'react-native'
import React from 'react'
import useAppStore from '#/store';

const NotFoundPage = () => {
  const {strings} = useAppStore();
  return (
    <View>
      <Text>{strings.notfound.text}</Text>
    </View>
  )
}

export default NotFoundPage