
import ballerina/test;
import ballerina/io;

configurable string serviceUrl = ?;

final Web3 web3Client = check new (serviceUrl);
// final Client twitter = check new Client(config, serviceUrl);



// Test function for getting accounts
@test:Config {}
function testGetAccounts() returns error? {
    json result = check  web3Client.getAccounts();

    io:print(result);
}