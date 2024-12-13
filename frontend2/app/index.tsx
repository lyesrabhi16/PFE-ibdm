import Container from "#/components/Container";
import { Link } from "expo-router";
import { ActivityIndicator, Surface, Text } from "react-native-paper";

export default function Index() {
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
        <Text>Edit app/index.tsx to edit this screen.</Text>
        <Link href="/sign-in">
          <Text>Go to Signin</Text>
        </Link>
        <ActivityIndicator animating={true} />
      </Surface>
    </Container>
  );
}
