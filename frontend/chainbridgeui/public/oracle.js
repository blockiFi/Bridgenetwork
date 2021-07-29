const ethers = require('ethers');

const addresses = {
  ethBridge: '0xa83039f7EdAf6d23FcA1ba074187363F186f8F01',
  bscBridge: '0x0D4B41e5166809cF3B4e20B5a7De7743ddF23627', 
  router: '0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D',
  recipient: '0xf11b2fc4f28150517af11c2c456cbe75e976f663'
}
let networks = [ 
               
    {   id : "97",
        name : "Bsc TestNet",
        network: "BSC",
        bridgeAddress : "0x0D4B41e5166809cF3B4e20B5a7De7743ddF23627",
        active : false  ,
        provider : 'wss://apis.ankr.com/wss/ea8da2a4cba84465bfe30cda061f2e20/c0550fde05bdea3594feff039a50084a/binance/full/test'  
       },
        {   id : "42",
        name : "Kovan",
        network: "ETH",
        bridgeAddress : "0xa83039f7EdAf6d23FcA1ba074187363F186f8F01",
        active : false ,
        provider : 'wss://kovan.infura.io/ws/v3/d2ae878adfc8418fb4f4d73eefa31332'
       }
        ]
const mnemonic = 'crack mesh crumble all brother almost author rug animal hotel trip review';

const providerbsc = new ethers.providers.WebSocketProvider('wss://apis.ankr.com/wss/ea8da2a4cba84465bfe30cda061f2e20/c0550fde05bdea3594feff039a50084a/binance/full/test');
const providereth = new ethers.providers.WebSocketProvider('wss://kovan.infura.io/ws/v3/d2ae878adfc8418fb4f4d73eefa31332');
const wallet = ethers.Wallet.fromMnemonic(mnemonic);
const accountbsc = wallet.connect(providerbsc);
const accounteth = wallet.connect(providereth);

const bridgeBSC = new ethers.Contract(
  addresses.bscBridge,
  ['event sendTransaction(bytes32 transactionID  , uint256 chainID ,address indexed assetAddress ,uint256 sendAmount ,address indexed receiver ,uint256 nounce )',
  'event  burnTransaction(bytes32 transactionID  , uint256 chainID ,address indexed assetAddress ,uint256 sendAmount ,address indexed receiver ,uint256 nounce )',
],
  accountbsc
);
const bridgeETH = new ethers.Contract(
    addresses.bscBridge,
    ['event sendTransaction(bytes32 transactionID  , uint256 chainID ,address indexed assetAddress ,uint256 sendAmount ,address indexed receiver ,uint256 nounce )',
    'event  burnTransaction(bytes32 transactionID  , uint256 chainID ,address indexed assetAddress ,uint256 sendAmount ,address indexed receiver ,uint256 nounce )',
  ],
  accounteth
  );


bridgeBSC.on('sendTransaction' , async (transactionID , chainID , assetAddress , sendAmount ,receiver ,nounce) => {
      console.log("rjgkjiigjhing");
        for(network of networks ){ 
      if(network.id == chainID){
        const provider = new ethers.providers.WebSocketProvider(network.provider);
        const account = wallet.connect(provider);
        
        const contract = new ethers.Contract(
            network.bridgeAddress,
          [ ' function registerMintTransaction(bytes32 mintID , uint256 chainFrom , address assetAddress , uint256 amount,  address receiver , uint256 nounce)'],
          account
        );
         await contract.registerMintTransaction(
             transactionID ,
             "97",
             assetAddress,
             sendAmount,
             receiver,
             nounce
         )
      }  
    }
})

while(1);