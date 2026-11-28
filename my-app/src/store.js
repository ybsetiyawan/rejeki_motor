import Vue from 'vue';
import Vuex from 'vuex';
import router from './router';
import api from './services/api';

Vue.use(Vuex);

const sanitizeUserSession = (user) => {
  if (!user || typeof user !== 'object') return null;
  const sanitized = { ...user };
  // Pastikan token tidak pernah disimpan di localStorage (token dikelola via cookie HttpOnly).
  delete sanitized.token;
  return sanitized;
};

const getSavedUser = () => {
  try {
    const parsed = JSON.parse(localStorage.getItem('user'));
    return sanitizeUserSession(parsed);
  } catch (e) {
    return null;
  }
};

// Bersihkan sisa key token lama di localStorage jika ada.
localStorage.removeItem('token');
const savedUser = getSavedUser();
if (savedUser) {
  localStorage.setItem('user', JSON.stringify(savedUser));
}

export default new Vuex.Store({
  state: {
    user: savedUser,
    userRole:
      localStorage.getItem('userRole') ||
      (savedUser && savedUser.data && savedUser.data.id_role) ||
      null,
    logoutTimer: null
  },
  mutations: {
    setUser(state, user) {
      const sanitized = sanitizeUserSession(user);
      state.user = sanitized;
      localStorage.setItem('user', JSON.stringify(sanitized));
      localStorage.removeItem('token');

      const roleId =
        sanitized && sanitized.data
          ? sanitized.data.id_role
          : sanitized && sanitized.id_role;
      if (roleId !== undefined && roleId !== null) {
        state.userRole = roleId;
        localStorage.setItem('userRole', roleId);
      }
    },
    setUserRole(state, role) {
      state.userRole = role;
      localStorage.setItem('userRole', role);
    },
    logout(state) {
      state.user = null;
      state.userRole = null;
      localStorage.removeItem('user');
      localStorage.removeItem('token');
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
      api.post('/logout').catch(() => {});
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
      }, 36000000); // 36000000 ms = 10 jam
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
