type ContractJson record {
    ContractMethod[] abi = [];
};

type ContractMethod record {
    string 'type;
    string name?;
    MethodInput[] inputs = [];
    MethodOutput[] outputs = [];
    string? stateMutability;
    boolean constant?;
};

type MethodInput record {
    string name;
    string 'type;
    string? internalType;
};

type MethodOutput record {
    string name;
    string 'type;
    string? internalType;
};
