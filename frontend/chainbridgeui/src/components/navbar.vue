<template>
  <div>
    <nav class="navbar navbar-expand-lg navbar-light bg-light bg-transparent">
      <div class="container-fluid">
          <img src='../assets/bridge_full_logo.png' alt="" width="" height="35" class="mt-1">
        
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
          <span class="navbar-toggler-icon bread-crumbs"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarSupportedContent">
          <ul class="navbar-nav me-auto mx-auto mb-0 mt-2 mb-lg-0">
            <li class="nav-item">
              <a class="nav-link active" aria-current="page" href="/">Token Bridge</a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="/nft">NFT Bridge</a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="/build">Build</a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="/farm">Farm</a>
            </li>
            <li class="nav-item">
              <a class="nav-link" href="/stake">Stake</a>
            </li>
          </ul>
          <form class="d-flex">
            <button class="btn-outline-bridge" v-if="!user.id" @click="login">Connect Wallet</button>
            <button class="btn-outline-bridge" v-if="user.id">{{addressFormated}}</button>
          </form>
        </div>
      </div>
    </nav>
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
