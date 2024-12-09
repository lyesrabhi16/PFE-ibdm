import { View, Text } from 'react-native'
import React from 'react'
import DropdownButton from '@/components/DropdownButton'
import { Menu } from 'react-native-paper'

const LanguageSwitchButton = () => {
  return (
    <DropdownButton 
        
        selectedKey={0}
        MenuItems={[
            {
                title: "EN",
                onPress: () => console.log("EN"),            
            },
            {
                title: "FR",
                onPress: () => console.log("FR"),            
            },
            {
                title: "AR",
                onPress: () => console.log("AR"),            
            }
        ]}
    
    />
  )
}

export default LanguageSwitchButton