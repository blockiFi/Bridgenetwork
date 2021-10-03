<template> 
<div class="background">
  <navbar></navbar>
  <div class="d-flex justify-content-center mt-5">
    <div class="coming-soon">
      <!-- <h1>Coming soon...</h1> -->
      <img src="../assets/nft.svg" width="70%" height=""/>
      <h1>Coming soon...</h1>
    </div>
  </div>
</div>
</template>
<script>
import navbar from '../components/navbar.vue';

export default {
  components: {
    navbar,
    // transfer,
    },
    data(){
        return {

        }
    },
    computed: {
     
    }
}
</script>