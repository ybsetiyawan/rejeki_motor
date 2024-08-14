import Vue from 'vue';
import Vuex from 'vuex';
import router from './router';

Vue.use(Vuex);

export default new Vuex.Store({
  state: {
    user: JSON.parse(localStorage.getItem('user')) || null,
    userRole: localStorage.getItem('userRole') || null,
    logoutTimer: null
  },
  mutations: {
    setUser(state, user) {
      state.user = user;
      localStorage.setItem('user', JSON.stringify(user));
      localStorage.setItem('userRole', user.id_role);
    },
    setUserRole(state, role) {
      state.userRole = role;
      localStorage.setItem('userRole', role);
    },
    logout(state) {
      state.user = null;
      state.userRole = null;
      localStorage.removeItem('user');
      localStorage.removeItem('userRole');
    },
    setLogoutTimer(state, timer) {
      state.logoutTimer = timer;
    },
    clearLogoutTimer(state) {
      if (state.logoutTimer) {
        clearTimeout(state.logoutTimer);
        state.logoutTimer = null;
      }
    }
  },
  actions: {
    setUser({ commit, dispatch }, user) {
      commit('setUser', user);
      dispatch('startLogoutTimer');
    },
    setUserRole({ commit }, role) {
      commit('setUserRole', role);
    },
    logout({ commit }) {
      commit('logout');
      commit('clearLogoutTimer');
      if (router.currentRoute.path !== '/login') {
        router.push('/login');
      }
    },
    startLogoutTimer({ commit, dispatch }) {
      commit('clearLogoutTimer');
      const timer = setTimeout(() => {
        dispatch('logout');
      }, 300000); // 300000 ms = 5 menit
      commit('setLogoutTimer', timer);
    },
    resetLogoutTimer({ dispatch }) {
      dispatch('startLogoutTimer');
    }
  },
  getters: {
    user: state => state.user,
    userRole: state => state.userRole
  }
});