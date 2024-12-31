import { useAppStore } from '#/store';
import { LoginFormViewProps } from '#/types';
import { LockOutlined, UserOutlined } from '@ant-design/icons';
import { Button, Checkbox, Form, Input, Flex } from 'antd';

const LoginForm = (props: LoginFormViewProps) => {
  const { strings } = useAppStore();
  return (
    <Form
      name="login"
      initialValues={{ remember: true }}
      style={{ maxWidth: 360 }}
      onFinish={props.onSubmit}
      size='large'
    >
      <Form.Item
        name="username"
        rules={[{ required: true, message: strings.login.username_empty_message }]}
      >
        <Input prefix={<UserOutlined />} placeholder={strings.login.username} />
      </Form.Item>
      <Form.Item
        name="password"
        rules={[{ required: true, message: strings.login.password_empty_message }]}
      >
        <Input prefix={<LockOutlined />} type="password" placeholder={strings.login.password} />
      </Form.Item>
      <Form.Item>
        <Flex justify="space-between" wrap align='center'>
            <Form.Item name="remember" valuePropName="checked" noStyle>
                <Checkbox>{strings.login.remember_me}</Checkbox>
            </Form.Item>
            <div className='flex w-full xs:w-auto ps-12 justify-end '>
            <a href="" className='text-end content-end'>{strings.login.forgot_password_question}</a>
            </div>
          
        </Flex>
      </Form.Item>

      <Form.Item>
        <Button block type="primary" htmlType="submit">
          {strings.login.login}
        </Button>
      </Form.Item>
    </Form>
  );
};

export default LoginForm;