import { View, Text } from 'react-native'
import React, { useEffect } from 'react'
import { getSystemTheme } from '@/utils/themePicker'
import { PaperProvider } from 'react-native-paper'
import useAppStore from '@/store'

type props = {
    children: React.ReactNode[] | React.ReactNode,
}

const ThemedPaperProvider = (props:props) => {
    const { theme, setTheme } = useAppStore();
    useEffect(() => {
    const _theme = getSystemTheme();
        setTheme(_theme);
    }, [])

  return (
    <PaperProvider theme={theme}>
        {props.children}
    </PaperProvider>
  )
}

export default ThemedPaperProvider