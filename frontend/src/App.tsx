import '#static/css/App.css';
import LoginPage from '#pages/LoginPage';
import { Route, Routes } from 'react-router-dom';

function App() {
  
  return (
    <div className='App w-screen m-0 p-0'>
          <Routes>
            <Route index element={<>Index</>} />
            <Route path="/login" element={<LoginPage />} />
          </Routes>
    </div>
  )
}

export default App
