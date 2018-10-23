[%%version 0.401] 

type storage = (address, nat)map
    
let%entry main
    (parameter : bytes)
    (storage : storage) = 
  
  match (Bytes.unpack parameter : (address * nat * bool * bytes option)option) with 
  |None -> Current.failwith "Incorrect data format"
  |Some data ->  
      let (receiver, amount, isContract, tokenFallBack) = data in 
      let sender = Current.sender() in
      if sender = receiver then Current.failwith "Sender cannot be Receiver"; 
      match Map.find sender storage with 
      |None -> Current.failwith "No balance found" 
      |Some sender_balance ->  
          (*if amount > sender_bal then Current.failwith "Not enough balance";*) 
          match%nat sender_balance - amount with 
          |Minus m -> Current.failwith ("Not enough balance", m)
          |Plus new_balance ->
              let storage = Map.add sender new_balance storage in 
              match Map.find receiver storage with 
              |None -> 
                  let storage = Map.add receiver amount storage in
                  (([]:operation list), storage)
              |Some receiver_balance -> 
                  let storage = Map.add receiver (receiver_balance + amount) storage in 
                  (([] : operation list), storage)
                  
    
    
  
