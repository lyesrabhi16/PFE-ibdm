import '#static/css/App.css';
import { Flex } from 'antd';
import LoginPage from '#pages/LoginPage';

function App() {

  return (
    <div className='w-full h-full'>
      <Flex justify='center' gap="large" align='center' wrap="nowrap" className="App">
          <LoginPage/>
      </Flex>
    </div>
  )
}

export default App
