import React from 'react';
import Navbar from '../Components/Navbar';

const Dashboard: React.FC = () => {
  const handleLogout = () => {
    console.log('Logout clicked!');
    // Ajouter une logique de déconnexion ici si nécessaire
  };

  return (
    <div>
      <Navbar isLoggedIn={true} username="Utilisateur" onLogout={handleLogout} />
      <div className="dashboard-content">
        <h1>Bienvenue dans votre tableau de bord</h1>
      </div>
    </div>
  );
};

export default Dashboard;
