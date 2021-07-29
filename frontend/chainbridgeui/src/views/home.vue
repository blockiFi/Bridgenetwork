<template> 
<div>
   {{base_url}}
    <topbar></topbar>
    <swap></swap>
</div>
</template>
<script>
export default {
    data(){
        return {

        }
    },
    computed: {
     base_url : function (){
         return this.$store.state.constant.base_url;
     }
    }
}
</script>