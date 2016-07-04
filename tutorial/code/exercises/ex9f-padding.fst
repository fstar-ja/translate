module Pad
open Array

(* a coercion; avoid it? *)
assume val n2b: n:nat {( n < 256 )} -> Tot uint8
assume val b2n: b:uint8 -> Tot (n:nat { (n < 256) /\ n2b n = b })

type bytes = seq byte (* concrete byte arrays *) 
type nbytes (n:nat) = b:bytes{length b == n} (* fixed-length bytes *)

let blocksize = 32 
type block = nbytes blocksize
type text = b:bytes {(length b < blocksize)}

val pad: n:nat { 1 <= n /\ n <= blocksize } -> Tot (nbytes n)

let pad n = 
  Array.create n (n2b (n-1))  

(* pad 1 = [| 0 |]; pad 2 = [| 1; 1 |]; ... *)


val encode: a: text -> Tot block 
let encode a = append a (pad (blocksize - length a))

val inj: a: text -> b: text -> Lemma (requires (Array.Equal (encode a) (encode b)))
                                     (ensures (Array.Equal a b))
                                     [SMTPat (encode a); SMTPat (encode b)]
let inj a b = admit()


val decode: b:block -> option (t:text { b = encode t })
let decode (b:block) = 
  let padsize = b2n(index b (blocksize - 1)) + 1 in
  if op_LessThan padsize blocksize then 
    let (plain,padding) = split b (blocksize - padsize) in
    if padding = pad padsize
    then Some plain
    else None   
  else None



module BMAC
open Pad 

let keysize = 16 (* these are the sizes for SHA1 *) 
let macsize = 20  
type key = nbytes keysize
type tag = nbytes macsize

opaque type key_prop : key -> block -> Type
type pkey (p:(block -> Type)) = k:key{key_prop k == p}

assume val keygen: p:(block -> Type) -> pkey p
assume val mac:    k:key -> t:block{key_prop k t} -> tag
assume val verify: k:key -> t:block -> tag -> b:bool{b ==> key_prop k t}

module TMAC
open Pad 

let keysize = BMAC.keysize
let macsize = BMAC.macsize
type key = BMAC.key
type tag = BMAC.tag

opaque type bspec (spec: (text -> Type)) (b:block) = 
  (forall (t:text). b = encode t ==> spec t)

opaque type key_prop : key -> text -> Type
type pkey (p:(text -> Type)) = 
  k:key{key_prop k == p /\ BMAC.key_prop k == bspec p}

val keygen: p:(text -> Type) -> pkey p
val mac:    p:(text -> Type) -> k:pkey p -> t:text{p t} -> tag
val verify: p:(text -> Type) -> k:pkey p -> t:text -> tag -> b:bool{b ==> p t}

(*implement these functions*)
