import Vue from 'vue'
import App from './App.vue'
import router from './router'
import vuetify from './plugins/vuetify'
import store from './store'
import { setUnauthorizedHandler } from './services/api'

Vue.config.productionTip = false

setUnauthorizedHandler(() => {
  store.dispatch('logout')
})

new Vue({
  router,
  vuetify,
  store,
  render: h => h(App)
}).$mount('#app')