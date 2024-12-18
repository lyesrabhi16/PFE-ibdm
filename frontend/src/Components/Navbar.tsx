import React from 'react';
import { Layout, Menu } from 'antd';
import '../static/css/Navbar.css';
import { useNavigate } from "react-router-dom";

const { Header } = Layout;

interface NavbarProps {
  isLoggedIn: boolean;
  username?: string;
  onLogout?: () => void;
}

const Navbar: React.FC<NavbarProps> = ({ isLoggedIn, username, onLogout }) => {
    const navigate = useNavigate(); // Hook pour naviguer entre les pages
    const handleLoginClick = () => {
        navigate("/login"); // Redirige vers la page de connexion
      };
    
  return (
    <Header className="navbar">
      <div className="logo">IFRI</div>
      <Menu theme="dark" mode="horizontal" className="menu">
        {isLoggedIn ? (
          <>
            <Menu.Item key="username">Bienvenue, {username}</Menu.Item>
            <Menu.Item key="logout" onClick={onLogout}>
              Logout
            </Menu.Item>
          </>
        ) : (
          <Menu.Item key="login"onClick={handleLoginClick}>Login</Menu.Item>
        )}
      </Menu>
    </Header>
  );
};

export default Navbar;
