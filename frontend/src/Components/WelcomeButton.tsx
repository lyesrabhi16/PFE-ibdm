import React from 'react';
import { Button } from 'antd';

interface WelcomeButtonProps {
  onClick: () => void;
}

const WelcomeButton: React.FC<WelcomeButtonProps> = ({ onClick }) => {
  return (
    <Button type="primary" onClick={onClick} style={{ marginTop: '20px' }}>
      Login
    </Button>
  );
};

export default WelcomeButton;
