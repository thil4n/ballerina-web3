import ballerina/io;
import ballerina/test;

configurable string serviceUrl = ?;

final Web3 web3Client = check new (serviceUrl);

// Test function for getting accounts
@test:Config {}
function testGetAccounts() returns error? {
    string[] _ = check web3Client.getAccounts();
}

// Test function for getting accounts
@test:Config {}
function testGetBalance() returns error? {
    decimal balance = check web3Client.getBalance("0xca249532ba7a24b505bd0a7229949ee4c74ccb45");

    io:print(weiToEther(balance));
}

// Test function for getting accounts
@test:Config {}
function testGetBlockNumber() returns error? {
    decimal blockNumber = check web3Client.getBlockNumber();

    io:print(blockNumber);
}
