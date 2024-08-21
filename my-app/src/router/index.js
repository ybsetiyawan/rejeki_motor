import Vue from 'vue';
import VueRouter from 'vue-router';
import store from '../store'; // Import Vuex store
import HomeView from '../views/HomeView.vue';
import CustomerView from '../components/master/CustomerView.vue';
import SatuanView from '../components/master/SatuanView.vue';
import JenisItemView from '../components/master/JenisItemView.vue';
import ItemView from '../components/master/ItemView.vue';
import UserView from '../components/master/UserView.vue';
import LoginView from '../components/LoginView.vue';
import ReceiptView from '../components/transaction/ReceiptView.vue';
import SupplierView from '../components/master/SupllierView.vue';
import ReportTransaksiView from '../components/report/ReportTransaksi.vue';
import ReportTransaksiReceipt from '../components/report/ReportTransaksiReceipt.vue';
import Swal from 'sweetalert2';
import TransaksiNew from '../components/transaction/TransaksiNew.vue';
import ReturSupplier from '../components/transaction/ReturSupplier.vue'
import ReturCustomer from '../components/transaction/ReturCustomer.vue'
import ReportReturSupplier from '../components/report/ReportReturSupllier.vue'
import ReportReturCustomer from '../components/report/ReportReturCustomer.vue'
import ReportStok from '../components/report/ReportStok.vue'

Vue.use(VueRouter);

const routes = [
  {
    path: '/',
    name: 'home',
    component: HomeView,
    meta: { requiresAuth: true }
  },
  {
    path: '/customer',
    name: 'customer',
    component: CustomerView,
    meta: { requiresAuth: true, requiresRole: 1 }
  },
  {
    path: '/supplier',
    name: 'supplier',
    component: SupplierView, // Pastikan ini benar
    meta: { requiresAuth: true, requiresRole: 1 }
  },
  {
    path: '/satuan',
    name: 'satuan',
    component: SatuanView,
    meta: { requiresAuth: true, requiresRole: 1 }
  },
  {
    path: '/jenis_item',
    name: 'jenis_item',
    component: JenisItemView,
    meta: { requiresAuth: true, requiresRole: 1 }
  },
  {
    path: '/items',
    name: 'items',
    component: ItemView,
    meta: { requiresAuth: true, requiresRole: 1 }
  },
  {
    path: '/users',
    name: 'users',
    component: UserView,
    meta: { requiresAuth: true, requiresRole: 1 }
  },
  {
    path: '/login',
    name: 'login',
    component: LoginView
  },
  {
    path: '/penjualan',
    name: 'penjualan',
    component: TransaksiNew,
    meta: { requiresAuth: true, requiresRole: [1] }
  },
  {
    path: '/pembelian',
    name: 'pembelian',
    component: ReceiptView,
    meta: { requiresAuth: true, requiresRole: [1] }
  },
  {
    path: '/retursupplier',
    name: 'retursupllier',
    component: ReturSupplier,
    meta: { requiresAuth: true, requiresRole: [1] }
  },
  {
    path: '/returcustomer',
    name: 'returcustomer',
    component: ReturCustomer,
    meta: { requiresAuth: true, requiresRole: [1] }
  },
  {
    path: '/report_penjualan',
    name: 'report_penjualan',
    component: ReportTransaksiView,
    meta: { requiresAuth: true, requiresRole: [1, 2] }
  },
  {
    path: '/report_pembelian',
    name: 'report_pembelian',
    component: ReportTransaksiReceipt,
    meta: { requiresAuth: true, requiresRole: [1, 2] }
  },
  {
    path: '/report_retursupplier',
    name: 'report_retursupplier',
    component: ReportReturSupplier,
    meta: { requiresAuth: true, requiresRole: [1, 2] }
  },
  {
    path: '/report_returcustomer',
    name: 'report_returcustomer',
    component: ReportReturCustomer,
    meta: { requiresAuth: true, requiresRole: [1, 2] }
  },
  {
    path: '/report_stokbarang',
    name: 'report_stokbarang',
    component: ReportStok,
    meta: { requiresAuth: true, requiresRole: [1, 2] }
  },
];

const router = new VueRouter({
  mode: 'history',
  base: process.env.BASE_URL,
  routes
});

router.beforeEach((to, from, next) => {
  const loggedInUser = store.getters.user;
  const userRole = store.getters.userRole;

  if (to.matched.some(record => record.meta.requiresAuth)) {
    if (!loggedInUser && to.path !== '/login') {
      next({
        path: '/login',
        query: { redirect: to.fullPath }
      });
    } else {
      if (to.matched.some(record => record.meta.requiresRole)) {
        const requiredRoles = Array.isArray(to.meta.requiresRole) ? to.meta.requiresRole : [to.meta.requiresRole];
        if (!requiredRoles.includes(Number(userRole))) {
          Swal.fire({
            title: 'Anda tidak memiliki akses ke halaman ini',
            icon: 'error',
            width: '400px',
          });
        } else {
          next();
        }
      } else {
        next();
      }
    }
  } else {
    next();
  }
});

export default router;