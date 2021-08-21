import Vue from 'vue'
import App from './App.vue'
import store from "./store";
import router from './router';
import store from "./store";
import VueToast from 'vue-toast-notification';
import 'vue-toast-notification/dist/theme-sugar.css';

Vue.use(VueToast , {position : 'top-right'});

Vue.config.productionTip = false
Vue.component('loader', require('./components/loader.vue').default);
Vue.component('topbar', require('./components/topbar.vue').default);
Vue.component('swap', require('./components/swap.vue').default);

new Vue({
  router,
  store,
  render: h => h(App),
}).$mount('#app')
