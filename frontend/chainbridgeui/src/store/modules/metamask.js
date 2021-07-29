import Web3 from 'web3';



const state = {
    user : {},
    poolBalance : 0,
    netWorkID : 0
  }
//  
const getters = {
   

}
const actions = {
   async getNetwork({commit}){
    window.web3 = new Web3(window.ethereum);
    let id = await window.web3.eth.net.getId();
    commit("setNeworkID" , id);
   },
   async innitaliseWeb3(){
        if (window.ethereum) {
        window.web3 = new Web3(window.ethereum);
        window.ethereum.enable();
        
    }
    },
    validateMetamaskAvailable (){
        return new Promise( (resolve , reject) => {
            if (typeof window.ethereum !== 'undefined') {
                resolve("available");
              }
              reject({message : "Metamask not installed, please install metamask to use this App."})
        });
    },
   async loginMetaMask({commit}){
        const accounts =   await window.web3.eth.getAccounts(); 
        const account = accounts[0];
        commit("setUser" , account);
        return new Promise( (resolve ) => {
            resolve("Login Successful");
        });
     
    },

    setUser({commit} ,account) {
        commit("setUser" , account);  
    }
}

const mutations = {
    setUser(state ,account){
        let user = {};
        user.id  =  Math.floor(Math.random() * 1000) + 1;
        user.address = account ;
        state.user = user;
        localStorage.setItem("user",JSON.stringify(user));
    },
    setNeworkID(state ,id){
    state.netWorkID = id;
    }
};

export default {
    namespaced: true,
    state,
    getters,
    actions,
    mutations
}