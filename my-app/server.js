const express = require('express');
const path = require('path');
const app = express();

// Ganti 'dist' dengan direktori build aplikasi Vue Anda
app.use(express.static(path.join(__dirname, 'dist')));

// Tambahkan middleware untuk mengarahkan semua permintaan ke index.html
app.get('*', (req, res) => {
  res.sendFile(path.join(__dirname, 'dist', 'index.html'));
});

const PORT = process.env.PORT || 8080;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});