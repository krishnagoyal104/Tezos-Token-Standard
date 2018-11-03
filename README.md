# Tezos-Token-Standard

## Details:
* There is a single entry point which accepts bytes as argument.   
* The arguments are (receiver_address, amount, isContract, contract_data option) which are packed into bytes and then deserialized by the contract.  
* If the tokens are being sent to a contract, isContract should be set to true and some bytes can be provided which will be used as argument to call the contract's entry point.
* This is useful in case tokens are being sent to a dex contract.  

## Todo:

~~Add specifications similar to ERC223 standard.~~
