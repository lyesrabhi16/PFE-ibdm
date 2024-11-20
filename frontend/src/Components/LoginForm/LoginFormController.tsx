import { LoginFormView } from "#/Components/LoginForm";
import { constants } from "#/constants";
import { Request_Login } from "#/requests";
import { useAppStore } from "#/store";
import { LoginFormViewOnSubmitHandler } from "#/types";
import { log } from "#/utils";
import { message } from "antd";

const LoginFormController = () => {
  const { strings } = useAppStore();
  const onSubmit:LoginFormViewOnSubmitHandler = (values) => {

    message.loading({
      key: "login",
      type: "loading",
      content: strings.MESSAGES.logging_loading,
    });
    Request_Login(values.username, values.password, values.remember)
      .then((res) => {
        message.destroy("login");
        message.success(strings.MESSAGES.login_success, constants.MESSAGE_DURATIONS.short);
        log(res);
      })
      .catch((err) => {        
        message.destroy("login");
        message.error(strings.MESSAGES.login_failed + err.message, constants.MESSAGE_DURATIONS.long);
        log(err);
      });
  };

  return <LoginFormView onSubmit={onSubmit} />;
};

export default LoginFormController;
