import Vue from 'vue'
import App from './App.vue'
import store from "./store";
import router from './router';
import VueToast from 'vue-toast-notification';
import 'vue-toast-notification/dist/theme-sugar.css';
import 'bootstrap/dist/css/bootstrap.min.css';
import 'bootstrap/dist/js/bootstrap.bundle';
// import bootstrap from 'bootstrap';

Vue.use(VueToast , {position : 'top-right'});

Vue.config.productionTip = false
Vue.component('loader', require('./components/loader.vue').default);
Vue.component('topbar', require('./components/topbar.vue').default);
Vue.component('swap', require('./components/swap.vue').default);
Vue.component('navbar', require('./components/navbar.vue').default);
Vue.component('processing', require('./components/utilities/processing.vue').default);
Vue.component('transfer_success', require('./components/utilities/transfer_success.vue').default);
Vue.component('selection_btn', require('./components/utilities/selection_btn.vue').default);
Vue.component('trans_input', require('./components/utilities/trans_input.vue').default);
Vue.component('transfer', require('./components/transfer.vue').default);
Vue.component('select_network', require('./components/select_network.vue').default);

new Vue({
  router,
  store,
  render: h => h(App),
}).$mount('#app')
