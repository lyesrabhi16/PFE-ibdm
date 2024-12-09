import { View, Text } from 'react-native'
import React from 'react'
import { TextInput, TextInputProps } from 'react-native-paper'
import { getFillColor } from '@/utils/utils'

type props = {
    left_icon?: string,
    right_icon?: string,
} & TextInputProps

const CustomTextInput = (props:props) => {
  return (
    <TextInput
      mode='outlined'
      left={props.left_icon ? <TextInput.Icon color={getFillColor} icon={props.left_icon} />: undefined}
      right={props.right_icon ? <TextInput.Icon color={getFillColor} icon={props.right_icon} />: undefined}
     {...props}
    />
  )
}

export default CustomTextInput