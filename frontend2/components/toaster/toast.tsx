import Constants from "expo-constants";
import { useEffect, useRef } from "react";
import { Animated } from "react-native";
import { Surface, Text, useTheme } from "react-native-paper";
const Toast = ({
  t,
  updateHeight,
  offset,
}: {
  t: any;
  updateHeight: any;
  offset: any;
}) => {
  // Animations for enter and exit
  const fadeAnim = useRef(new Animated.Value(0.5)).current;
  const posAnim = useRef(new Animated.Value(-80)).current;
  const theme = useTheme();
  useEffect(() => {
    Animated.timing(fadeAnim, {
      toValue: t.visible ? 1 : 0,
      duration: 300,
      useNativeDriver: true,
    }).start();
  }, [fadeAnim, t.visible]);

  useEffect(() => {
    Animated.spring(posAnim, {
      toValue: t.visible ? offset : -80,
      useNativeDriver: true,
    }).start();
  }, [posAnim, offset, t.visible]);

  return (
    <Animated.View
      style={{
        position: "absolute",
        left: 0,
        right: 0,
        zIndex: t.visible ? 9999 : undefined,
        alignItems: "center",
        opacity: fadeAnim,
        transform: [
          {
            translateY: posAnim,
          },
        ],
      }}
    >
      <Surface
        onLayout={(event) => updateHeight(event.nativeEvent.layout.height)}
        style={{
          margin: Constants.statusBarHeight + 10,
          borderRadius: 30,
          flexDirection: "row",
          alignItems: "center",
          paddingVertical: 8,
          paddingHorizontal: 12,
          ...t.style,
        }}
        key={t.id}
      >
        <Text>{t.icon} </Text>
        <Text
          style={{
            padding: 2,
            flex: 1,
            textAlign: "center",
          }}
        >
          {t.message}
        </Text>
      </Surface>
    </Animated.View>
  );
};

export default Toast;
