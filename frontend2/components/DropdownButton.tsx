import React, { ReactNode } from "react";
import {
  Button,
  Text,
  ButtonProps,
  Icon,
  Menu,
  MenuItemProps,
  Surface,
} from "react-native-paper";
type props = {
  MenuItems: MenuItemProps[];
  selectedKey?: number;
  MenuVisible?: boolean;
  onPress?: ButtonProps["onPress"];
};
const DropdownButton = (props: props) => {
  let { MenuItems, selectedKey, MenuVisible, onPress } = props;

  if (props.MenuVisible == undefined) {
    MenuVisible = false;
  }
  if (props.selectedKey == undefined) {
    selectedKey = 0;
  }
  if (props.onPress == undefined) {
    onPress = () => {
      setSelectedKey(s => (s! + 1) % MenuItems.length);
    };
  }

  const [menu_visible, setMenuVisible] = React.useState(MenuVisible);
  const [selected_key, setSelectedKey] = React.useState(selectedKey);
  return (
    <Surface
      style={{
        display: "flex",
        flexDirection: "row",
        justifyContent: "space-around",
        alignItems: "center",
      }}
    >
      <Button
        compact
        style={{
          borderRadius: 0,
        }}
        onPress={onPress}
      >
        <Text>
          {MenuItems[selected_key as number].title}
        </Text>
      </Button>
      <Menu
        visible={menu_visible as boolean}
        onDismiss={() => setMenuVisible(false)}
        anchorPosition="bottom"
        anchor={
          <Button
            children={<Icon source="dots-vertical" size={20} />}
            compact
            style={{
              borderRadius: 0,
              borderLeftWidth: 1,
            }}
            onPress={() => setMenuVisible(true)}
          />
        }
      >
        {MenuItems.map((item, index) => (
          <Menu.Item
            key={index}
            {...item}
            onPress={(e) => {
              setSelectedKey(index);
              item.onPress && item.onPress(e);
            }}
          />
        ))}
      </Menu>
    </Surface>
  );
};

export default DropdownButton;
