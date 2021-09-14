<template>
    <div class="row">
        <div class="col-sm-12 col-md-8 offset-md-2">
            <div style="margin-top: 20vh;">
                <div  class="bg d-flex align-items-center justify-content-center">
                      <div class="box">
                        <h2 style="color:white" cl @click="flipDirection" ass="text-white mb-4">Transfer <span  v-show="forward"> <i  class="fas fa-long-arrow-alt-right"></i></span>
                            <span  v-show="!forward"    ><i class="fas fa-long-arrow-alt-left"></i></span>
                        </h2>
                    
                        <p>What token would you like to transfer</p>
            
                        <select class="bridge-select mb-5" v-model="activeAsset" >
                            <option  v-for="wrappedAsset in assets" :value="wrappedAsset" :key="wrappedAsset.id">{{wrappedAsset.name}}   ({{wrappedAsset.symbol}})</option>
                        </select>
                          <div class="row">
                            <div class="col">
                              <p>Network To?</p>
                                <select class="bridge-select mb-5" v-model="toChain">
                                    <option  v-for="activeNetwork in activenetworks" :key="activeNetwork.id" :value="activeNetwork">{{activeNetwork.name}}   ({{activeNetwork.bridgeAddress}})</option>
                              </select>
                            </div>
                            <div class="col">
                              <p class="grayed">Amount <span @click="amount = activeAsset.balance"> ({{new Intl.NumberFormat().format(activeAsset.balance)}})</span></p>
                               <input class="bridge-select mb-5 mt-5" value="" placeholder="Amount of Token" type="number" v-model="amount"/>
                             </div>
                             <div class="col">
                                <p >Reciever </p>
                                <input class="bridge-select mb-5 mt-5" type="text" placeholder="Enter Address" v-model="reciever"/>
                               </div>
                          </div>
                         
                          <button v-if="viewbutton && approve" class="bridge-btn" @click="approveSpend" :disabled="activeapprove"> <span v-show="activeapprove"><i   class="fa fa-refresh fa-spin"></i></span> <span v-show="!activeapprove">Approve</span> </button>
                
                          <button v-if="viewbutton && transferbutton"  class="bridge-btn" @click="transferAsset" :disabled="activetransfer"> <span v-show="activetransfer"><i  class="fa fa-refresh fa-spin" ></i></span><span  v-show="!activetransfer">Transfer</span></button>
                       
                      </div>
                    </div>
                </div>
        </div>
    </div>
   
</template>
<script>
import Web3 from 'web3';
import  {bridgeAbi , ERC20Abi} from "../store/modules/abi";
export default {
    data(){
        return {
            approve : true,
            transferbutton: false,
            amount : 0,
            activeAsset : {},
            forward : true,
            toChain : {},
            reciever: '',
            activeapprove : false,
            activetransfer: false
           
        }
    },
    watch : {
    activeAsset : function(newNetwork){
        if(newNetwork.address == "0x0000000000000000000000000000000000000000"){
            this.approve = false;
        }
    }
    },
    computed : {
        viewbutton : function(){
            if(this.toChain != {} && this.activeAsset != {} && this.amount != 0  ){
                return true;
            }return false;
        },
        activeNetwork : function(){
          return this.$store.state.swap.activeNetwork;  
        },
         nativeAssets : function(){
         return this.$store.state.swap.nativeAssets;
         },
         wrappedAssets:function(){
          return this.$store.state.swap.wrappedAssets;
         },
        assets: function(){
            if(this.forward){
                return this.nativeAssets;

            }return this.wrappedAssets;
        },
        networks : function() {
          return this.$store.state.swap.networks;
        },
        supportedAssetNetwork : function(){
          if( this.activeAsset.supportedChains != null )
          {
              return this.activeAsset.supportedChains;
          } return [];
        },
        networkID : function(){
            return "97";
        },
        activenetworks : function(){
            let net = [];
          if(this.forward){
             for(let xindex = 0 ; xindex < this.supportedAssetNetwork.length ; xindex++){
                 for(let yindex = 0 ; yindex < this.networks.length ; yindex++){
                     if(this.supportedAssetNetwork[xindex] == this.networks[yindex].id){
                         net.push(this.networks[yindex]);
                     }
                 }
             }
          } 
          else {
              for(let yindex = 0 ; yindex < this.networks.length ; yindex++){
                     if(this.activeAsset.networkID == this.networks[yindex].id){
                         net.push(this.networks[yindex]);
                     }
                 }

          }
          return net;
        }
    },
    methods: {
        flipDirection(){
            console.log("teste")
            this.forward = !this.forward;
        },
        async transferAsset(){
            if(!window.web3.utils.isAddress(this.reciever)){
                this.$toast.error("Invalid Reciever Address");
                return;
            }
            this.activetransfer = true;
            console.log("eer");
             window.web3 = new Web3(window.ethereum);
             window.bridge   =  await new window.web3.eth.Contract( bridgeAbi ,this.activeNetwork.bridgeAddress );
            try {
                if(this.forward){
                    let send = await window.bridge.methods.send(this.toChain.id ,this.activeAsset.address ,window.web3.utils.toBN(window.web3.utils.toWei(this.amount)).toString(),this.reciever).send({from: this.$store.state.currentUser.user.address});
                    console.log(send);
                }else{
                    let send = await window.bridge.methods.burn(this.activeAsset.address ,window.web3.utils.toBN(window.web3.utils.toWei(this.amount)).toString(),this.reciever).send({from: this.$store.state.currentUser.user.address});
                    console.log(send); 
                }
                 
                this.$toast.success("Transfer successfull");
                this.transferbutton = false;
                this.approve = true;
                this.activetransfer = false;
                this.$store.dispatch("swap/loadAssets" ); 
            }
            catch(error){
                  this.activetransfer = false;
                this.$toast.error(error.message); 
            }
        },
        async approveSpend(){
            // if(this.activeAsset.balance < this.amount){
            //     this.$toast.error("insuficient balance");
            // }
            this.activeapprove =true;
            console.log( this.activeAsset.address)
            console.log( this.activeNetwork.bridgeAddress)
            console.log(this.$store.state.currentUser.user.address)
             window.web3 = new Web3(window.ethereum);
             window.currentasset1   =  await new window.web3.eth.Contract( ERC20Abi ,this.activeAsset.address);
            try {
                 await window.currentasset1.methods.approve(this.activeNetwork.bridgeAddress ,window.web3.utils.toBN(window.web3.utils.toWei(this.amount)).toString() ).send({from: this.$store.state.currentUser.user.address});
                 this.$toast.success("Approval successfull");
                  this.transferbutton = true;

                   this.approve = false;
                   this.activeapprove =false;
            }
            catch(error){
                this.activeapprove = false;
                this.$toast.error(error.message); 
            }
            //  responce.then(
            //     () => {
            //         this.$toast.success("approval suucessful");
            //         this.transferbutton = true;
            //         this.approve = false;
            //     }
            // ).catch(
            //     error => {
            //        this.$toast.error(error.message);  
            //     }
            // )
           
        //    console.log();
        //     if(responce.blockNumber){
        //         this.$toast.success("aproval successful");
        //     }else{
        //          this.$toast.error(responce.message);  
        //     }
            // this.$store.dispatch("swap/approveSpend" , {
            //     amount : window.web3.utils.toBN(this.amount).toString(),
            //     asset : this.activeAsset.address
            // }).then(
            //     () => {
            //         this.$toast.success("approval suucessful");
            //         this.transferbutton = true;
            //         this.approve = false;
            //     }
            // ).catch(
            //     error => {
            //        this.$toast.error(error.message);  
            //     }
            // )
        //    window.web3 = new Web3(window.ethereum);
           
        //    window.currentasset   =  await new window.web3.eth.Contract( ERC20Abi , this.activeAsset.address);
        //    let res =   await window.currentasset.methods.approve(this.activeNetwork.bridgeAddress , window.web3.utils.toBN(window.web3.utils.toWei(this.amount)).toString() ).send({from: this.$store.state.currentUser.user.address});
    
        //    if(res){
        //        
        //    }
        },
        
    },
    mounted() {
      this.$store.dispatch("swap/loadAssets" )  
    },
}
</script>