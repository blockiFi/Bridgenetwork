// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;
/// A multi chain , Multi Asset bridge
/// samuel eke


contract chainbridge {
struct nativeAsset {
    address assetAddress;
    uint256 minTransfer;
    uint256 maxTransfer;
    uint256 balance;
    uint256 transferFee;
    bool active;

}
struct chainBridge {
    uint256 chainBridgeID;
    uint256 netWorkId;
    mapping (address => nativeAsset) nativeAssets;
    mapping (address => bool ) activeNativeAssets;

}
mapping(uint256 => chainBridge ) chainBridges;
mapping(uint256 => bool ) isBridgeActive;

  constructor (uint chainBridgeID , uint256 netWorkId) {
      chainBridge storage newbridge = chainBridges[chainBridgeID];
      newbridge.chainBridgeID = chainBridgeID;
      newbridge.netWorkId = netWorkId;

      isBridgeActive[chainBridgeID] = true;


  } 
  function isActiveChain(uint256 chainBridgeID) public view returns(bool){
      return isBridgeActive[chainBridgeID];
  }

}

