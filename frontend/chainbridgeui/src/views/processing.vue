<template> 
<div class="background">
  <navbar></navbar>
  <div class="main-box">
    <processing></processing>
  </div>
</div>
</template>
<script>
import navbar from '../components/navbar.vue';
import processing from '../components/utilities/processing.vue';


export default {
  components: {
    navbar,
    processing,
    },
    data(){
        return {

        }
    },
    computed: {
     
    }
}
</script>