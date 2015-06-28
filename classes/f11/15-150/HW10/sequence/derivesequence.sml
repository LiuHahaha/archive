functor DeriveSequence (S : SEQUENCECORE) :> SEQUENCE =
struct
  open S

  fun mapreduce f b c s = reduce c b (map f s)

  (* TODO:  this is a buggy implementation of to string. to wit:
   *
   * val test = map Char.toString(explode "hello");
   * - foldr (fn (a,b) => a ^ "." ^ b) "" test;
   * val it = "h.e.l.l.o." : string
   *
   * so this won't produce the desired string. it works with the parallel
   * version, but not the sequential version that I fixed to use
   * vector.foldr. It shouldn't work with the parallel version; that's
   * buggy too.
   *)
  (* fix this by stealing 210 implementation + spec for reduce*)
  fun chomp s = String.substring(s,0,(String.size s) - 2)
  fun toString (s, ts) =
      "[" ^ (chomp (mapreduce ts "" (fn (a,b) => a ^ ", " ^ b ) s)) ^ "]"

  fun repeat (x,n) = tabulate (fn _ => x) n

  fun zip (sa, sb) = tabulate (fn n => (nth sa n, nth sb n))
                              (Int.min(length sa, length sb))

  fun append (s1, s2) = hidet (Node (s1, s2))

  fun empty () : 'a seq = hidel Nil
  fun singleton x = hidet (Leaf x)

  (* I'm not sure this should be here. Sure, it /can/ be implemented in terms of
   * the operations in SEQUENCECORE, but for certain implementations (eg.
   * vectors) it can be implemented directly rather more efficiently.
   * - MRA
   *)
  fun split s 0 = (empty (), s)
    | split s i =
      case showt s
       of Empty => (empty (), empty ())
        | Leaf x => (singleton x, empty ())
        | Node (l,r) =>
          let val ls = length l
          in case Int.compare (i, ls)
              of LESS => let val (ll, lr) = split l i
                         in (ll, append (lr, r))
                         end
               | EQUAL => (l, r)
               | GREATER => let val (rl, rr) = split r (i - ls)
                            in (append (l, rl), rr)
                            end
          end

  (* why are we using #1 and #2? --- IEV*)
  (* because it's the most elegant way to express these particular cases?
   *
   * I know, I know, they're "bad style". But while "don't use #<n>" is good
   * /general/ advice (not least because they often cause type-inference to
   * fail), that's because if you don't tell people this they'll use projection
   * functions /instead of/ pattern-matching when they really want /both/ values
   * out of the tuple, which is highly opaque. But in this case a projection is
   * exactly what we want - we want to grab the first or second element out of a
   * pair and ignore the rest.
   *
   * --- Michael "comments are an excuse to rant" Arntzenius *)
  (* Okay, okay. --- I "let's abuse svn" EV *)
  fun take s i = #1 (split s i)
  fun drop s i = #2 (split s i)

  fun cons (x, s) = hidel (Cons (x,s))

  fun flatten ss = reduce append (empty ()) ss
end
