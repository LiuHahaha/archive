(* ideally, this would be in SeqUtils, 
   but we wanted to separate the code you write into a different file *)

structure LookAndSay : sig
                         val look_and_say : ('a * 'a -> bool) -> 'a Seq.seq -> (int * 'a) Seq.seq
                     end =
struct
  fun look_and_say (eq : 'a * 'a -> bool) (s : 'a Seq.seq)
      : (int * 'a) Seq.seq =
      let
        fun lasHelp (s : 'a Seq.seq, x : 'a, acc : int) : 'a Seq.seq * int =
            case (Seq.showl s) of
              Seq.Nil => (s,acc)
            | Seq.Cons (y,ys) => (case (eq (x,y)) of
                         true => lasHelp (Seq.hidel s, x, acc + 1)
                       | false => (s,acc))
      in
        case (Seq.showl s) of
          Seq.Nil => Seq.empty
        | Seq.Cons (x,xs) => let
                                 val (rest, acc) = lasHelp(s, x, 0)
                             in
                                 Seq.hidel (Seq.Cons ((acc,x), Seq.showl (look_and_say (eq,rest))))
                             end
      end
end
