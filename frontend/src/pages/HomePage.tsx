import { Button, Layout } from "antd";
import Navbar from "#/Components/Navbar"; 
import { useNavigate } from "react-router-dom";

const { Content } = Layout;




const HomePage = ({ isLoggedIn, username, onLogout }) => {
  const navigate = useNavigate(); // Pour naviguer vers la page de login

  const handleLoginClick = () => {
    navigate("/login"); // Redirige vers la page de connexion
  };

  return (
    <Layout style={{ minHeight: "100vh" }}>
      {/* Barre de navigation */}
      <Navbar isLoggedIn={isLoggedIn} username={username} onLogout={onLogout} />

      {/* Contenu principal */}
      <Content
        style={{
          display: "flex",
          justifyContent: "center",
          alignItems: "center",
          flexDirection: "column",
          textAlign: "center",
          backgroundColor: "#f0f2f5",
          padding: "20px",
        }}
      >
        {/* Titre */}
        <h1
          style={{
            fontSize: "48px", // Taille du texte
            color: "black",   // Couleur du texte
            marginBottom: "20px",
          }}
        >
          Welcome to IFRI Platform
        </h1>

        {/* Bouton Login */}
        {!isLoggedIn && (
          <Button
            type="primary"
            size="large"
            onClick={handleLoginClick}
            style={{
              fontSize: "16px",
              padding: "10px 20px",
            }}
          >
            Login
          </Button>
        )}
      </Content>
    </Layout>
  );
};

export default HomePage;
