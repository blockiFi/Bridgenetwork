import Web3 from 'web3';
import  {bridgeAbi , ERC20Abi} from "./abi";
const state = {
    wrappedAssets : [],
    nativeAssets : [],
    address: "",
    assetSupportedNetworks : [],
    activeNetwork : {},
    networks : [ 
          { 
            id : "97",
            name : "Bsc TestNet",
            network: "BSC",
            bridgeAddress : "0xF8FE9aA0A440e14691ea1F1e7EA376540ab7a898",
            active : false    
           },
            {   id : "4",
            name : "Rinkby",
            network: "ETH",
            bridgeAddress : "0xF8E17D2FD227569d691EdbE3d428E1da674a31DD",
            active : false    
           },
        //     {   id : "787",
        //     name : "n2 TestNet",
        //     network: "BSC",
        //     bridgeAddress : "e",
        //     active : false    
        //    },
        //     {   id : "887",
        //     name : "n2 TestNet",
        //     network: "BSC",
        //     bridgeAddress : "e",
        //     active : false    
        //    },
        //     {   id : "8787",
        //     name : "n2 TestNet",
        //     network: "BSC",
        //     bridgeAddress : "e",
        //     active : false    
        //    },
        //     {   id : "888",
        //     name : "n2 TestNet",
        //     network: "BSC",
        //     bridgeAddress : "e",
        //     active : false    
        //    }
            ]
    
}

const getters = {}
const actions = {
    async approveSpend({state},data){
        window.web3 = new Web3(window.ethereum);
        window.currentasset1   =  await new window.web3.eth.Contract( ERC20Abi , data.address);
       await window.currentasset1.methods.approve(state.activeNetwork.bridgeAddress ,window.web3.utils.toBN(window.web3.utils.toWei(data.amount)).toString() ).send({from: this.state.currentUser.user.address});
         
    },
    async loadAssets({state, commit} ){
        window.web3 = new Web3(window.ethereum);
        let id = await window.web3.eth.net.getId();
        let network = {};
        state.networks.forEach(net => {
            if(net.id == id){
                network = net;
                commit("setActiveNetwork" ,network );
            }
        });
        window.bridge   =  await new window.web3.eth.Contract( bridgeAbi ,network.bridgeAddress);
      let nativeAssets = await window.bridge.methods.getnativeAssetsList().call({from: this.state.currentUser.user.address});
      let foriegnAssets = await window.bridge.methods.getforiegnAssetsList().call({from: this.state.currentUser.user.address});
      commit("clearAssets");
    //   nativeassets.forEach(async (asset) => 
      for(let asset of foriegnAssets)
      {
        window.currentasset   =  await new window.web3.eth.Contract( ERC20Abi ,asset);
        let name = await window.currentasset.methods.name().call({from: this.state.currentUser.user.address});
        let symbol = await window.currentasset.methods.symbol().call({from: this.state.currentUser.user.address});
        let balance = await window.currentasset.methods.balanceOf(this.state.currentUser.user.address).call({from: this.state.currentUser.user.address});
        let chainID = await window.bridge.methods.foriegnAssetChain(asset).call({from: this.state.currentUser.user.address});
        
        commit("setaddress" , this.state.currentUser.user.address);
         commit("addWrappedAsset" , {
             id : Math.floor(Math.random() * 1000) + 1,
             name : name,
             symbol  : symbol,
             address : asset,
             balance : window.web3.utils.fromWei(balance),
             networkID : chainID,
            
         })

      }
      
        for(let asset of nativeAssets ){ 
         window.currentasset   =  await new window.web3.eth.Contract( ERC20Abi ,asset);
        let name = await window.currentasset.methods.name().call({from: this.state.currentUser.user.address});
        let symbol = await window.currentasset.methods.symbol().call({from: this.state.currentUser.user.address});
        let balance = await window.currentasset.methods.balanceOf(this.state.currentUser.user.address).call({from: this.state.currentUser.user.address});
        let supportedChains = await window.bridge.methods.getSupportedchainIds(asset).call({from: this.state.currentUser.user.address});
        
        commit("addNativeAsset" , {
             id : Math.floor(Math.random() * 1000) + 1,
             name : name,
             symbol  : symbol,
             address : asset,
             supportedChains :supportedChains,
             balance :  window.web3.utils.fromWei(balance)
         })

      } 
      
     
    },
    // getAssetSupportedNetworks({commit}, address){
    //     let id = await window.web3.eth.net.getId();
    //     if(network.id == id){
    //         window.bridge   =  await new window.web3.eth.Contract( bridgeAbi ,network.bridgeAddress);
    //         let supportedChains = await window.bridge.methods.getSupportedchainIds(address).call({from: this.state.currentUser.user.address});
    
    //     }
    // }
}

const mutations = {
    clearAssets(state){
        state.wrappedAssets = [];
        state.nativeAssets = [];
    },
    addWrappedAsset(state , asset){
        state.wrappedAssets.push(asset);
    } ,
    addNativeAsset(state , asset){
        state.nativeAssets.push(asset);
    },
    setaddress(state ,  address){
        state.address = address;
    },
    setActiveNetwork(state , network){
        state.activeNetwork = network;
    }
    
};

export default {
    namespaced: true,
    state,
    getters,
    actions,
    mutations
}