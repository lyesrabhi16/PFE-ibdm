const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;

// Middlewares
app.use(express.json());

// Route de test
app.get('/', (req, res) => {
    res.send('Backend is running!');
});

// Lancement du serveur
app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});
