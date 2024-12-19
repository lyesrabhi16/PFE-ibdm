import '#static/css/App.css';
import LoginPage from '#pages/LoginPage';
import Dashboard from '#pages/Dashboard';
import HomePage from '#pages/homepage';
import { Route, Routes } from 'react-router-dom';

function App() {
  
  return (
    <div className='App w-screen m-0 p-0'>
          <Routes>
            <Route path="/" element={<HomePage />} />
            <Route path="/login" element={<LoginPage />} />
            <Route path="/dashboard" element={<Dashboard />} />
          </Routes>
    </div>
  )
}

export default App
