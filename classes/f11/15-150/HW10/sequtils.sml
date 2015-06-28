structure SeqUtils : sig
                         (* assume sequence is non-empty *)
                         val reduce1 : ('a * 'a -> 'a) -> 'a Seq.seq -> 'a 

                         val look_and_say : ('a * 'a -> bool) -> 'a Seq.seq -> (int * 'a) Seq.seq

                         val filtermap : ('a -> 'b option) -> 'a Seq.seq -> 'b Seq.seq

                         val max : ('a * 'a -> order) -> 'a -> 'a Seq.seq -> 'a

                         (* take n s returns the sequence consisting of the first n elements of s,
                            or raises Seq.Range if s does not have n elements
                            *)
                         val take : 'a Seq.seq -> int -> 'a Seq.seq 

                         (* take n s returns s with its first n elements removed,
                            or raises Seq.Range if s does not have n elements
                            *)
                         val drop : 'a Seq.seq -> int -> 'a Seq.seq 

                         val seqToList : 'a Seq.seq -> 'a list
                         val seqFromList : 'a list -> 'a Seq.seq 

                     end =
struct
    fun reduce1 (c : 'a * 'a -> 'a) (s : 'a Seq.seq) : 'a = 
        let
            fun mergeo (x : 'a option , y : 'a option) : 'a option = 
                case (x , y) of
                    (NONE , y) => y
                  | (x , NONE) => x
                  | (SOME x, SOME y) => SOME (c (x,y))
        in
            case Seq.mapreduce SOME NONE mergeo s of
                SOME x => x
              | NONE => raise Fail "called reduce1 on an empty sequence"
        end


  fun look_and_say (eq : 'a * 'a -> bool) (s : 'a Seq.seq)
      : (int * 'a) Seq.seq = LookAndSay.look_and_say eq s 

  fun filtermap f s = 
      (Seq.map (fn SOME x => x | NONE => raise Fail "bug in filtermap")
       (Seq.filter (fn SOME _ => true | _ => false) (Seq.map f s)))


  fun max (cmp : 'a * 'a -> order) (min : 'a) (s : 'a Seq.seq) =
        Seq.reduce (fn (x, y) => (case cmp (x, y) of
                                      LESS => y
                                    | _ => x))
                   min
                   s

  fun take s n = 
      case Seq.length s >= n of
          true => (#1 (Seq.split s n))
        | false => raise Seq.Range

  fun drop s n = 
      case Seq.length s >= n of
          true => (#2 (Seq.split s n))
        | false => raise Seq.Range

  fun seqToList s = Seq.mapreduce (fn x => [x]) [] op@ s
  fun seqFromList l = List.foldr Seq.cons (Seq.empty()) l

end

structure TestUtil = 
struct

    val test = Seq.cons (((), 84), Seq.cons (((), 32), (Seq.cons (((), ~4), (Seq.cons (((), 0),Seq.empty()))))))
    structure O = OrderUtils (PairSecondOrder (struct type left = unit structure Right = IntLt end))
    val test = SeqUtils.reduce1 O.min test

end
