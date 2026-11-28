// api.js

import axios from 'axios';

let unauthorizedHandler = null;

/**
 * Mendaftarkan callback saat API mengembalikan 401 (mis. sesi/cookie kedaluwarsa atau tidak valid).
 */
export const setUnauthorizedHandler = (handler) => {
  unauthorizedHandler = typeof handler === 'function' ? handler : null;
};

const isLoginRequest = (url = '') => {
  return String(url).split('?')[0].endsWith('/login');
};

const isLogoutRequest = (url = '') => {
  return String(url).split('?')[0].endsWith('/logout');
};

const api = axios.create({
  baseURL: process.env.VUE_APP_API_URL || 'http://localhost:4000',
  withCredentials: true,
});

api.interceptors.response.use(
  (response) => response,
  (error) => {
    const status = error && error.response && error.response.status;
    const requestUrl = error && error.config && error.config.url;

    if (
      status === 401 &&
      !isLoginRequest(requestUrl) &&
      !isLogoutRequest(requestUrl) &&
      unauthorizedHandler
    ) {
      unauthorizedHandler();
    }

    return Promise.reject(error);
  }
);

export default api;
