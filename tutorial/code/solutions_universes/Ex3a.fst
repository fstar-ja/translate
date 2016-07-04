module Ex3a

(* Here are some other types for factorial:
    val factorial: nat -> Tot nat
    val factorial: nat -> Tot (x:int{x > 0})
    val factorial: int -> int *)
val factorial: x:int{x>=0} -> Tot int
let rec factorial n = 
  if n = 0 then 1 else Prims.op_Multiply n (factorial (n - 1))
