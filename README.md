# Tezos-Token-Standard
* Token standard for Tezos having specs similar to ERC223.   

## Specs:
* There is a single entry point which accepts bytes as argument.   
* The arguments are receiver(address), amount(tez), isContract(bool), contract_data option(bytes option). These should be packed into bytes which are then deserialized by the contract.  
* If the tokens are being sent to a contract, isContract should be set to true and some bytes need to be provided for the target contract's entry point.
* This is useful in case tokens are being sent to a dex contract. Tokens no longer need to be approved to the contract. These can be  directly sent to the target contract and trigger the tokenFallback function, the argument for which will be sender(address) and amount(nat), packed into bytes.  
