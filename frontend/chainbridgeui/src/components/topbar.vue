<template>
    <div>
    <button class="btn btn-primary connect-button" v-if="!user.id" @click="login">Connect</button>
    <button class="btn connect-address" v-if="user.id">{{addressFormated}}</button>
    </div>
</template>
<script>
export default {
    data(){
        return {
          
        }
    },
    computed: {
    user : function(){
     return this.$store.state.currentUser.user;
   },
    addressFormated : function(){
     if(!this.user.address) return "";
     return this.user.address.substring(0 ,6) + "...." + this.user.address.substring(this.user.address.length -4 ,this.user.address.length)
   },
    },
    mounted () {
        setInterval(() => {
            if( localStorage.getItem("user") != null && this.user.id != JSON.parse(localStorage.getItem("user")).id){
               this.$store.dispatch("currentUser/setUser" , localStorage.getItem("user") != null ? JSON.parse(localStorage.getItem("user"))  : {});   
            }
        }, 1000);
    },
    methods : {
        
        login(){
        this.$store.dispatch('metamask/innitaliseWeb3').then(
            response =>{
              console.log(response);
              this.$store.dispatch('metamask/validateMetamaskAvailable')
              .then(
            response =>{
              console.log(response);
              this.$store.dispatch('metamask/loginMetaMask').then(
              () =>  {
                    this.$toast.success("login successful");
                    this.$store.dispatch("currentUser/setUser" , localStorage.getItem("user") != null ? JSON.parse(localStorage.getItem("user"))  : {});
              }) 
            }
            ).catch (
                error => {
                    this.$toast.error(error);
                }
            )
            }
        ).catch (
            error => {
                this.$toast.error(error);
            }
        )
        }
    }
}
</script>