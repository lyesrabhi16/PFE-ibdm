import Container from "#/components/Container";
import useAppStore from "#/store";
import { Link } from "expo-router";
import { ActivityIndicator, Surface, Text } from "react-native-paper";

export default function Index() {
  const {strings} = useAppStore();
  return (
    <Container>
      <Surface
        mode="flat"
        style={{
          flex: 1,
          justifyContent: "center",
          alignItems: "center",
        }}
      >
        <Text>{strings.index.text1}</Text>
        <Link href="/sign-in">
          <Text>{strings.index.text2}</Text>
        </Link>
        <ActivityIndicator animating={true} />
      </Surface>
    </Container>
  );
}
