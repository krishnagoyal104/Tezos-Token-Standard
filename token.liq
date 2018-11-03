[%%version 0.403] 

type storage = {
  balances: (address, nat)map;
  version : nat;                             
  totalSupply : nat;
  decimals : nat;
  name : string;
  symbol : string;
  owner : address;
}
    
let%init storage
    (owner : address) (totalSupply : nat) (decimals : nat)
    (name : string) (symbol : string) =  
  {
    balances = (Map : (address, nat)map);
    version = 1p;
    totalSupply;
    decimals;
    name;
    symbol;
    owner;
  }
  
    contract type BytesContract = sig
               type storage
               val%entry tokenFallback : bytes -> storage -> (operation list * storage)
             end
    
let%entry main
    (parameter : bytes)
    (storage : storage) = 
  
  match (Bytes.unpack parameter : (address * nat * bool * bytes option)option) with 
  |None -> Current.failwith "Incorrect data format"
  |Some data ->  
      let (receiver, amount, isContract, contractData) = data in 
      let sender = Current.sender() in
      if sender = receiver then Current.failwith "Sender cannot be Receiver"; 
      let storage = match Map.find sender storage.balances with 
        |None -> Current.failwith "No balance found" 
        |Some sender_balance ->  
          (*if amount > sender_bal then Current.failwith "Not enough balance";*) 
            match is_nat (sender_balance - amount) with  
            |None -> Current.failwith "Not enough balance"  
            |Some new_balance -> storage.balances <- Map.add sender new_balance storage.balances in 
      let storage = match Map.find receiver storage.balances with 
        |None -> storage.balances <- Map.add receiver amount storage.balances                                        
        |Some receiver_balance -> storage.balances <- Map.add receiver (receiver_balance + amount) storage.balances in  
      if isContract = true then  
        match contractData with  
        |None -> Current.failwith "You need to provide some data"  
        |Some contract_data ->
            match (Contract.at receiver : BytesContract.instance option) with  
            |None -> Current.failwith "Wrong Address or Contract Abi"  
            |Some contr -> 
                let op = Contract.call ~dest:contr ~amount:0tz ~entry:tokenFallback ~parameter:contract_data in   
                (([op]), storage)
      else  
        (([] : operation list), storage)  
                  
