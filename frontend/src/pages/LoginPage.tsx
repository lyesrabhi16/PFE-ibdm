import { Card, Flex } from "antd"

const LoginPage = () => {
  return (
    <div>
        <Card title="Welcome">
            <Flex className="Header" justify="center" align="center" wrap="nowrap" gap="small">
            <p>Log in to access the app</p>
            </Flex>
        </Card>
    </div>
  )
}

export default LoginPage