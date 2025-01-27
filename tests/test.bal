
import ballerina/test;
import ballerina/io;



configurable string serviceUrl = ?;

final Web3 web3Client = check new (serviceUrl);
// final Client twitter = check new Client(config, serviceUrl);



// Test function for getting accounts
@test:Config {}
function testGetAccounts() returns error? {
    string[] _ = check  web3Client.getAccounts();
}

function pow(decimal base, int exponent) returns decimal {
    decimal value = 1;
    foreach int i in 1...exponent {
        value = value * base;
    }
    return value;
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

        map<int> values = {
        "0": 0, "1": 1, "2": 2, "3": 3, "4": 4, "5": 5, "6": 6,
        "7": 7, "8" : 8, "9" : 9, "A" : 10, "B": 11, "C" :12,
        "D" : 13, "E" : 14, "F" : 15
        };

        int position = (length - i) - 1; 
        decimal power = pow(16, position);
        int value =  values[hexChar] ?: 0;
    
        decimalValue +=  value * power;
    }

    return decimalValue;
}

public function weiToEther(decimal weiAmount) returns decimal {
    decimal etherValue = weiAmount / 1e18;
    return etherValue;
}

// Test function for getting accounts
@test:Config {}
function testGetBalance() returns error? {
    string balance = check  web3Client.getBalance("0xca249532ba7a24b505bd0a7229949ee4c74ccb45");

    string sanitizedHex = balance.substring(2);

    decimal priceWei = check hexToDecimal(sanitizedHex);

    io:print(weiToEther(priceWei));
}