pragma solidity >=0.6.0;

/**
 * @title FundMe
 * @dev Accepts Payment
 */

// importing from: https://www.npmjs.com/package/@chainlink/contracts
import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";

// // SafeMathChainlink library
// import "@chainlink/contracts/src/v0.8/vendor/SafeMathChainlink.sol";

contract FundMe {
    // keep track of the sender and amount sent
    mapping(address => uint256) public addressAmountFundedFrom;

    address public owner;

    // list of funders's address
    address[] public funders;

    // setting visibility to internal
    AggregatorV3Interface internal priceFeed;

    /**
     * Constructor runs only once, at the time of contract deployment.
     */
    constructor() public {
        priceFeed = AggregatorV3Interface(
            0x8A753747A1Fa494EC906cE90E9f37563A8AF630e
        );
        owner = msg.sender;
    }

    /**
     * Get the version of AggregatorV3Interface
     */
    function getVersion() public view returns (uint256) {
        return priceFeed.version();
    }

    /**
     * Get the latest price of eth
     */
    function getLatestPrice() public view returns (uint256) {
        (, int256 price, , , ) = priceFeed.latestRoundData();
        return uint256(price * 10000000000);
    }

    /**
     * Converting ethAmount to current USD price.
     */
    function getConversionRate(uint256 ethAmount)
        public
        view
        returns (uint256)
    {
        uint256 ethPrice = getLatestPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / (10**18);
        return ethAmountInUsd;
    }

    /**
     * Allowing users to fund with minimum amount $50
     */
    function fund() public payable {
        uint256 minimumUSD = 50 * 10**18;
        require(
            getConversionRate(msg.value) >= minimumUSD,
            "You need to spend ETH >= $50 !"
        );

        addressAmountFundedFrom[msg.sender] += msg.value;
        funders.push(msg.sender);
    }

    /**
     * Allowing the owner of the contract withdraw funds.
     */
    modifier OnlyOwner(address _to) {
        require(_to == owner, "You are not allowed to withdraw !!!");
        _;
    }

    function withdraw(address payable _to) public payable OnlyOwner(_to) {
        // getting the address of the contract
        address fund_me = address(this);
        // transfering contract's balance to the owner's address
        _to.transfer(fund_me.balance);

        // updating balance of the every funding address to 0
        for (
            uint256 funderIndex = 0;
            funderIndex < funders.length;
            funderIndex++
        ) {
            address funder = funders[funderIndex];
            addressAmountFundedFrom[funder] = 0;
        }
        funders = new address[](0);
    }
}
