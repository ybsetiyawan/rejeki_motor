// import axios from 'axios';
import api from '../services/api';

export function loadCustomers() {
  // return axios.get('http://localhost:4000/m_customer')
  return api.get('/m_customer')
    .then(response => response.data);
}

// export function loadItems() {
//   // return axios.get('http://localhost:4000/m_item')
//   return api.get('/m_item')
//     .then(response => response.data);
// }

export function loadItems(currentPage, pageSize, searchQuery) {
  return api.get('/m_item', {
      params: {
          page: currentPage,
          pageSize: pageSize,
          search: searchQuery,
      },
  }).then(response => {
      return {
          items: response.data.items,
          total: response.data.total,
      };
  }).catch(error => {
      console.error('Error loading items:', error);
      throw error; // Melempar error agar bisa ditangani di tempat lain
  });
}

export function loadSuppliers() {
  // return axios.get('http://localhost:4000/m_supplier')
  return api.get('/m_supplier')
    .then(response => response.data);
}