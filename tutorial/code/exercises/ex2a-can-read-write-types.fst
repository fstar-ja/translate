module FileName
  type filename = string

module ACLs
  open FileName

  val canWrite : unit (* write a correct and precise type here *)
  let canWrite (f:filename) =
    match f with 
      | "demo/tempfile" -> true
      | _ -> false

  val canRead : unit (* write correct and precise type here *)
  let canRead (f:filename) =
    canWrite f               (* writeable files are also readable *)
    || f="demo/README"       (* and so is this file *)
