functor Jamboree (Settings : sig
                                 structure G : GAME
                                 val search_depth : int
                             end) : PLAYER  =
struct
  structure Game = Settings.G

  structure EstOrd = OrderUtils(EstOrder(Game))
  structure ShEst = ShowEst(Game)

  type edge = (Game.move * Game.est)

  datatype value = 
      BestEdge of edge
    | Pruned
  fun valueToString (v : value) : string = 
      case v of Pruned => "Pruned" | BestEdge (_,e) => "Value(" ^ ShEst.toString e ^ ")"

  type alphabeta = value * value (* invariant: alpha < beta *)
  fun abToString (a,b) = "(" ^ valueToString a ^ "," ^ valueToString b ^ ")"

  (* for alpha, we want max(alpha,Pruned) to be alpha, i.e.
     Pruned <= alpha for any alpha;
     otherwise order by the estimates on the edges
     *)
  fun alpha_is_less_than (alpha : value, v : Game.est) : bool = 
      case alpha of
          Pruned => true
        | BestEdge(_,alphav) => EstOrd.lt(alphav,v)
  fun maxalpha (v1,v2) : value = 
      case (v1,v2) of
          (Pruned,y) => y
        | (x,Pruned) => x
        | (BestEdge(_,e1), BestEdge(_,e2)) => case EstOrd.lt (e1,e2) of true => v2 | false => v1

  (* for beta, we want min(beta,Pruned) to be beta, i.e.
     beta <= Pruned for any beta;
     otherwise order by the estimates on the edges
     *)
  fun beta_is_greater_than (v : Game.est, beta : value) : bool = 
      case beta of
          Pruned => true
        | BestEdge(_,betav) => EstOrd.lt(v,betav)
  fun minbeta (v1,v2) : value = 
      case (v1,v2) of
          (Pruned,y) => y
        | (x,Pruned) => x
        | (BestEdge(_,e1), BestEdge(_,e2)) => case EstOrd.lt (e1,e2) of true => v1 | false => v2

  (* Task 1 *)
  fun updateAB (state : Game.state) ((alpha, beta) : alphabeta) (value : value) : alphabeta = raise Fail "unimplemented"

  (* Task 2 *)
  fun value_for (state : Game.state) ((alpha, beta) : alphabeta) : value = raise Fail "unimplemented"

  datatype result = Value of value | ParentPrune   (* an evaluation result *)
  fun resultToString r = case r of Value v => valueToString v | ParentPrune => "ParentPrune"

  (* Task 3 *)
  fun check_bounds ((alpha,beta) : alphabeta) (state : Game.state) 
                   (incomingMove : Game.move) (v : Game.est) : result = raise Fail "unimplemented"

  (* Task 4 *)
  fun evaluate (depth : int) (ab : alphabeta) (state : Game.state) (incomingMove : Game.move) : result = raise Fail "unimplemented"
          
  and search (depth : int) (ab : alphabeta) (state : Game.state) : value = raise Fail "unimplemented"

  (* Task 5 *)
  fun next_move s = raise Fail "unimplemented"
end
