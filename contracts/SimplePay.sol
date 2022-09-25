// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract SimplePay {
    using ECDSA for bytes32;

    uint public price;

    address public seller;
    address public buyer;

    enum State { Created, Locked, Inactive}
    State public state;
 
    constructor() payable {
        seller = 0xc98E9c69119eb0B764B0d5DCbC1532De8bfC2D4f; 
    }

    // 1:50000、台幣/5萬 = eth
    function cost(uint productPrice) public payable{
        price = productPrice;
    }

	// ECDSA橢圓曲線簽名演算法
    
    // 驗證簽名 
    function isMessageVaild(bytes memory _signature) public view returns (bool){      
        // 進行abi編碼
        bytes memory abiEncode = abi.encodePacked("HelloWorld");
        bytes32 messagehash = keccak256(abiEncode);
        bytes32 ethSignedMessageHash = ECDSA.toEthSignedMessageHash(messagehash);
        // 從簽名恢復地址
        address signer = ECDSA.recover(ethSignedMessageHash, _signature);

        if(msg.sender == signer){
            return (true);
        }else{
            return (false);
        }
    }

    modifier condition(bool _condition) {
        require(_condition);
        _;
    }

    modifier onlyBuyer() {
        require(msg.sender == buyer, "Only allow buyers to access.");
        _;
    }

    modifier onlySeller() {
        require(msg.sender == seller, "Allow seller access only.");
        _;
    }

    modifier inState(State _state) {
        require(state == _state, "The status of the order is not actionable.");
        _;
    }

    event Aborted();
    event PurchaseConfirmed();
    event ItemReceived();
 
   //買家下單支付以太幣後觸發
    function deposit(bytes memory _signature) public payable {
        require(msg.value == price, "Please pay according to the item price.");
        require(isMessageVaild(_signature), "Must need your signature.");

        emit PurchaseConfirmed();
        buyer = payable(msg.sender);
        state = State.Created;
        payable(seller).transfer(address(this).balance);
    }

    // 取消購物取回以太幣
    // 只允許賣家訪問
}