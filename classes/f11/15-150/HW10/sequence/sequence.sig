signature SEQUENCE =
sig
  include SEQUENCECORE

  val mapreduce : ('a -> 'b) -> 'b -> ('b * 'b -> 'b) -> 'a seq -> 'b

  val toString : 'a seq * ('a -> string) -> string

  val repeat  : ('a * int) -> 'a seq
  val zip     : ('a seq * 'b seq) -> ('a * 'b) seq
  val flatten : 'a seq seq -> 'a seq
  val split   : 'a seq -> int -> 'a seq * 'a seq
  val take    : 'a seq -> int -> 'a seq
  val drop    : 'a seq -> int -> 'a seq

  val empty : unit -> 'a seq
  val cons  : ('a * 'a seq) -> 'a seq

  val singleton : 'a -> 'a seq
  val append    : ('a seq * 'a seq) -> 'a seq


  (* TODO: For next year:
   *
   * - mapreduce should have a consistent type
   *   suggest ('a -> 'b) -> ('b * 'b -> 'b) -> 'b -> 'a seq -> 'b
   *     for "map, then reduce"
   *   OR ('b * 'b -> 'b) -> ('a -> 'b) -> 'b -> 'a seq -> 'b
   *     for the notional order of the constructors of trees
   *
   * - repeat should be curried.
   *
   * - functions taking an int and a seq should take the int first, unless there
   *   is a compelling reason otherwise. This makes the code easier to read.
   *
   * - almost everything should be curried, in particular cons, repeat, append.
   *   arguably zip shouldn't be curried, since that way the isomorphism between
   *   "pair of seqs" and "seq of pairs" is clearer.
   *)
end
