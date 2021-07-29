<template>
  <router-view></router-view>
</template>
<script>
export default {
  methods : {
    loadAccount (accounts){
       this.$store.dispatch("metamask/setUser" , accounts[0]);
       this.$store.dispatch("currentUser/setUser" , localStorage.getItem("user") != null ? JSON.parse(localStorage.getItem("user"))  : {});

    }
  },
  mounted() {
    this.$store.dispatch("currentUser/setUser" , localStorage.getItem("user") != null ? JSON.parse(localStorage.getItem("user"))  : {});
   
   this.$store.dispatch("metamask/getNetwork");
   this.$store.dispatch('metamask/innitaliseWeb3');
   window.ethereum.on('accountsChanged', function (accounts) {
    console.log(accounts[0]);
    let user = {};
        user.id  =  Math.floor(Math.random() * 1000) + 1;
        user.address = accounts[0];
        localStorage.setItem("user",JSON.stringify(user));
  })

  }
}
</script>