import React, { useEffect, useMemo, useState } from "react";
import DropdownButton from "#/components/DropdownButton";
import { languages } from "#/types";
import useAppStore from "#/store";
import { MenuItemProps } from "react-native-paper";

const LanguageSwitchButton = () => {
	const [SelectIndex, setSelectIndex] = useState(0);
	const { language, setLanguage } = useAppStore();
	const MenuItems: MenuItemProps[] = [];

	// fill the menu items with the languages available in languages enum
        Object.values(languages).forEach((lang, index) => {
            MenuItems.push({
                title: lang,
                onPress: () => {
					setSelectIndex(index);
                },
            });
        });
    

	useEffect(() => {
        setLanguage(Object.values(languages)[SelectIndex]);
	}, [language, SelectIndex]);
    
	return (
		<DropdownButton
			onPress={() => {
                const newIndex = (SelectIndex + 1) % MenuItems.length;
                setSelectIndex(newIndex);
            }}
			selectedKey={SelectIndex}
			MenuItems={MenuItems}
		/>
	);
};

export default LanguageSwitchButton;
