// import axios from 'axios';
import api from '../services/api';

export function loadCustomers() {
  // return axios.get('http://localhost:4000/m_customer')
  return api.get('/m_customer')
    .then(response => response.data);
}

export function loadItems() {
  // return axios.get('http://localhost:4000/m_item')
  return api.get('/m_item')
    .then(response => response.data);
}

export function loadSuppliers() {
  // return axios.get('http://localhost:4000/m_supplier')
  return api.get('/m_supplier')
    .then(response => response.data);
}