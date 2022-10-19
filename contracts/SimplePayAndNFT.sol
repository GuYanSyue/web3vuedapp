// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

contract SimplePayAndNFT is ERC721Enumerable, Ownable{
    using ECDSA for bytes32;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;
    
    string public baseURI = "ipfs://QmeiiJoud97FgBnmrjiaHk6PrBoiHDkaWPFfoonG3Hw5TU"; // 這一行是 NFT 該去哪裡找你的 MetaData
    bool public paused = false; // 可以拿來暫停或者開啟 Mint
    uint256 public cost = 0.0001 ether; // Mint 價格
    uint256 public maxSupply = 5; // 只有五個 NFT
    uint256 public maxMintAmount = 1; // 一次最多只能 Mint 一個
    uint public price;
    address public seller = 0xc98E9c69119eb0B764B0d5DCbC1532De8bfC2D4f;
    address public buyer;
    
    constructor() ERC721( "ShopCoinT2", "SCT2") payable {
	}


    // 提供給大家 Mint 的 Function(另外加上 payable 代表這個 function 可以接收乙太幣)
    function mint(uint256 _mintAmount) public payable {
        require(paused != true, "Sale must be active"); // 合約必須不是暫停
		require(_mintAmount > 0); // 每次必須鑄造超過 0 個
        //require(totalSupply() + _mintAmount <= maxSupply, "Sale would exceed max supply"); // 合約內代幣的量 + 鑄造的量 不可超過總發行數量
        require(_mintAmount <= maxMintAmount, "You can only adopt 1 BigBenFun at a time"); // 鑄造的數量不可以大於每次最大鑄造數量
        require(cost * _mintAmount <= msg.value, "Ether value sent is not correct"); // Mint 的價格不可以少於我們訂定的價格
      
        for(uint256 i = 0; i < _mintAmount; i++) {
            uint256 mintIndex = _tokenIdCounter.current();
            
            while(_exists(mintIndex)){
                i++;
            }
            
            // 接下來如果 Mint NFT 的編號如果小於初始提供的數量就讓使用者 Mint
            if (mintIndex <= maxSupply) {
                _safeMint(msg.sender, mintIndex);
                _tokenIdCounter.increment();
            }
        }
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    // 重新設定 baseURI
    function setBaseURI(string memory _newBaseURI) public onlyOwner {
        baseURI = _newBaseURI;
    }

    // 取得這個持有者有多少 NFT
    function walletOfOwner(address _owner) public view returns (uint256[] memory) {
        uint256 ownerTokenCount = balanceOf(_owner);
        uint256[] memory tokenIds = new uint256[](ownerTokenCount);
        for (uint256 i; i < ownerTokenCount; i++) {
            tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
        }
        return tokenIds;
    }

    // 查看使用者持有的 NFT MetaDate
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );

        string memory currentBaseURI = baseURI;
        return bytes(currentBaseURI).length > 0 ? string(abi.encodePacked(currentBaseURI, "/", Strings.toString(tokenId), ".json")) : "";
    }

    // 查看總提供數量
    function totalSupply() public view override returns (uint256) {
        return maxSupply;
    }

    // 重新設定 Mint 價格
    function setCost(uint256 _newCost) public onlyOwner() {
        cost = _newCost;
    }
    
    // 重新設定總提供量
    function setMaxSupply(uint256 _newMaxSupply) public onlyOwner() {
        maxSupply = _newMaxSupply;
    }
    
    // 重新設定一次能 Mint 的數量
    function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner() {
        maxMintAmount = _newmaxMintAmount;
    }
    
    // 開關販賣開關
    function pause() public onlyOwner {
        paused = !paused;
    }



    enum State { Created, Locked, Inactive}
    State public state;

    // 1:50000、台幣/5萬 = eth
    function itemcost(uint productPrice) public payable{
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