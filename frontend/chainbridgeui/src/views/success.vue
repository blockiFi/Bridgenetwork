<template> 
<div class="background">
  <navbar></navbar>
  <div class="main-box">
    <transfer_success></transfer_success>
  </div>
</div>
</template>
<script>
import navbar from '../components/navbar.vue';
import transfer_success from '../components/utilities/transfer_success.vue';

export default {
  components: {
    navbar,
    transfer_success,
    },
    data(){
        return {

        }
    },
    computed: {
     
    }
}
</script>