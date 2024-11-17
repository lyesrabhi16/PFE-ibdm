import LanguageSwitchButton from "#/Components/LanguageSwitchButton";
import LoginForm from "#/Components/LoginForm";
import { useStore } from "#/store";
import { Card, Flex, Space } from "antd";

const LoginPage = () => {
  const { strings } = useStore();

  

  return (
    <div className="w-screen h-screen flex flex-col flex-nowrap">
      <div className="flex flex-row flex-nowrap justify-end">
        <LanguageSwitchButton/>
      </div>
      <div
      className="w-full flex-1 flex justify-center items-center"
      >
        <Card className="xs:px-10 py-5" title={strings.login.title}>
          <Space direction="vertical" size="large">
            <Flex
              className="Header"
              vertical
              justify="center"
              align="center"
              wrap="nowrap"
              gap="1"
            >
              <p className="m-0 p-0 font-bold">
                {strings.login.welcomeMessage}
              </p>
              <p className="m-1 p-0">{strings.login.loginMessage}</p>
            </Flex>
            <LoginForm />
          </Space>
        </Card>
      </div>
    </div>

  );
};

export default LoginPage;
