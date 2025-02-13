// api.js

import axios from 'axios';

const api = axios.create({
  // baseURL: 'https://api-rejekimotor.ybss.my.id', // Ganti dengan basis URL Anda
  baseURL: 'http://localhost:4000', // Ganti dengan basis URL Anda
  // baseURL: 'http://103.217.145.67:4000', // Ganti dengan basis URL Anda
  // opsi lain bisa ditambahkan di sini jika diperlukan
});

export default api;
