import ballerina/io;

configurable string serviceUrl = ?;

final Web3 web3Client = check new (serviceUrl);
final Contract contract = check web3Client.createContract("SimpleStorage.json", "0x332974888039c79b52A94284bD5aE0034d8C4Af7");

public function main() returns error? {
    // string[] result = check web3Client.getAccounts();

    io:println("");


    contract.methodsCalll()
}

