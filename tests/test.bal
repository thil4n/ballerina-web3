
import ballerina/test;
import ballerina/io;
import ballerina/math;


configurable string serviceUrl = ?;

final Web3 web3Client = check new (serviceUrl);
// final Client twitter = check new Client(config, serviceUrl);



// Test function for getting accounts
@test:Config {}
function testGetAccounts() returns error? {
    string[] _ = check  web3Client.getAccounts();
}



public function hexToDecimal(string str) returns decimal|error {

    // Initialize the result
    decimal decimalValue = 0;
    int length = str.length();

    string hexString = str.toUpperAscii();

    if !hexString.matches(re `^[A-F0-9]+$`) {
        return error("Invalid hex string: Contains non-hexadecimal characters");
    }

    foreach int i in 0 ..< length {
        string hexChar = hexString[i];

        map<decimal> values = {
        "0": 0, "1": 1, "2": 2, "3": 3, "4": 4, "5": 5, "6": 6,
        "7": 7, "8" : 8, "9" : 9, "A" : 10, "B": 11, "C" :12,
        "D" : 13, "E" : 14, "F" : 15
        };

        float position = <float>(length - i) - 1; 
        decimal power = <decimal>float:pow(16, position);
        decimal value =  values[hexChar] ?: 0;
    
        decimalValue +=  value * power;
    }

    return decimalValue;
}

// Test function for getting accounts
@test:Config {}
function testGetBalance() returns error? {
    string balance = check  web3Client.getBalance("0xca249532ba7a24b505bd0a7229949ee4c74ccb45");

    string sanitizedHex = balance.substring(2);

    decimal priceWei = check hexToDecimal("3635c9adc5dea00000");

    io:print(priceWei);
}