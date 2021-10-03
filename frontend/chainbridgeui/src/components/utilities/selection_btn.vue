<template>
  <div class="">    
    <div class="trans-select-btn" style="">
        <div class="d-flex justify-content-evenly align-items-center mt-1">
          <img :src="require(`@/assets/${img}`)" width="40" height="40" alt="logo" >
          <h5>{{ name }}</h5>
          <i class="fa fa-angle-down mb-2 bridge-fa"></i>
        </div>
      </div>
  </div>
</template>
<script>
export default {
  props: ['name', 'img'],

  methods : {

  },
  mounted() {
  
  }
}
</script>