import ballerina/http;

// Function to send a response with JSON
public function jsonResponse(http:Caller caller, json payload, int statusCode) returns error? {
    http:Response resp = new;
    resp.setJsonPayload(payload);
    resp.statusCode = statusCode;
    check caller->respond(resp);
}

// Function to convert a hexadecimal string to a regular string
function hexToString(string hex) returns string|error {
    string result = "";
    foreach int i in int:range(0, hex.length(), 2) {
        string hexPair = hex.substring(i, i + 2);
        int byteValue = check int:fromHexString(hexPair);
        result += check string:fromCodePointInt(byteValue);
    }
    return result;
}

public function decodeData(string response) returns json|error {
    json[] listedNFTs = [];

    // Remove the leading '0x'
    string abiResponse = response.substring(2);

    // Extract the number of NFTs
    string numberOfNFTsHex = abiResponse.substring(64, 128);

    int numberOfNFTs = check int:fromString(numberOfNFTsHex.trim());

    int offset = 128 + 64 * numberOfNFTs; // skip metadata

    // Iterate over each NFT
    foreach int i in 0 ... numberOfNFTs - 1 {

        // Extract Token ID
        string tokenIDHex = abiResponse.substring(offset, offset + 64);
        int tokenID = check int:fromString(tokenIDHex.trim());

        // // Move to next field (Price)
        offset += 128;

        // // Extract Price
        string priceHex = abiResponse.substring(offset, offset + 64);
        int priceWei = check int:fromHexString(priceHex.trim());

        // Move to next field (URI length + URI)
        offset += 64;

        // // Extract Token URI length
        string uriLengthHex = abiResponse.substring(offset, offset + 64);
        int uriLength = check int:fromHexString(uriLengthHex.trim());

        // Move to the actual URI data (hex encoded string)
        offset += 64;
        string tokenURIHex = abiResponse.substring(offset, offset + (uriLength * 2));

        string tokenURI = check hexToString(tokenURIHex);

        json nftData = {
            "tokenID": tokenID,
            "priceWei": priceWei,
            "tokenURI": tokenURI
        };

        listedNFTs.push(nftData);

        offset += (uriLength * 2 + 56);
    }

    return listedNFTs;
}

function pow(decimal base, int exponent) returns decimal {
    decimal value = 1;
    foreach int i in 1 ... exponent {
        value = value * base;
    }
    return value;
}

# Description.
#
# + str - parameter description
# + return - return value description
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
            "0": 0,
            "1": 1,
            "2": 2,
            "3": 3,
            "4": 4,
            "5": 5,
            "6": 6,
            "7": 7,
            "8": 8,
            "9": 9,
            "A": 10,
            "B": 11,
            "C": 12,
            "D": 13,
            "E": 14,
            "F": 15
        };

        int position = (length - i) - 1;
        decimal power = pow(16, position);
        int value = values[hexChar] ?: 0;

        decimalValue += value * power;
    }

    return decimalValue;
}

public function weiToEther(decimal weiAmount) returns decimal {
    decimal etherValue = weiAmount / 1e18;
    return etherValue;
}

public function ethToWei(decimal etherValue) returns decimal {
    decimal weiAmount = etherValue * 1e18;
    return weiAmount;
}
