import Vue from 'vue'
import VueRouter from 'vue-router'

// import Home from '../views/home.vue';
import LandingPage from '../views/landing.vue';
import Processing from '../views/processing.vue'
import Success from '../views/success.vue'
import NFT from '../views/nft.vue'
import Build from '../views/build.vue'
import Farm from '../views/farm.vue'
import Stake from '../views/stake.vue'

Vue.use(VueRouter)



let routes = [
  { path: '/', component: LandingPage },
  { path: '/processing', component: Processing },
  { path: '/success', component: Success },
  { path: '/nft', component: NFT },
  { path: '/build', component: Build },
  { path: '/farm', component: Farm },
  { path: '/stake', component: Stake },
]
   
   const router = new VueRouter({
       mode: 'history',
     routes // short for `routes: routes`
   })


export default router
