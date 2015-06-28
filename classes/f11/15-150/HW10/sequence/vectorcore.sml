structure VectorCore :> SEQUENCECORE =
struct
  type 'a seq = 'a vector

  exception Range
  exception PassAlong

  val length = Vector.length

  fun nth s i = Vector.sub (s,i) handle Subscript => raise Range

  fun tabulate f n =
      Vector.tabulate (n, fn x => (f x handle Size => raise PassAlong))
      handle Size => raise Range
           | PassAlong => raise Size

  fun filter f s =
      Vector.fromList
          (Vector.foldr (fn (e, xs) => if f e then e::xs else xs) [] s)

  val map = Vector.map

  val reduce = Vector.foldr

  datatype 'a lview = Nil | Cons of 'a * 'a seq
  datatype 'a tview = Empty | Leaf of 'a | Node of 'a seq * 'a seq

  fun showl s =
      case length s
       of 0 => Nil
        | l => Cons(nth s 0, tabulate (fn i => nth s (i+1)) (l-1))

  fun hidel Nil = Vector.fromList []
    | hidel (Cons (x,xs)) = Vector.concat [Vector.fromList [x], xs]

  fun showt s =
      case length s
       of 0 => Empty
        | 1 => Leaf (nth s 0)
        | n =>
          let
            val mid = n div 2
          in
            Node (tabulate (nth s) mid,
                  tabulate (fn x => nth s (x + mid)) (n - mid))
          end

  fun hidet Empty = Vector.fromList []
    | hidet (Leaf x) = Vector.fromList [x]
    | hidet (Node(s1,s2)) = Vector.concat [s1,s2]
end
