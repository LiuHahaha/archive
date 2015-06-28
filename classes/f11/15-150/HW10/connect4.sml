(* the signature of game specifications. *)
signature CONNECT4_BOARD_SPEC =
  sig
    val num_cols : int
    val num_rows : int
  end

structure MiltonBradley : CONNECT4_BOARD_SPEC =
  struct
    val num_cols = 7
    val num_rows = 6
  end

functor Connect4 (Dim : CONNECT4_BOARD_SPEC) : GAME where type move = int  =
  struct
    datatype player = Minnie | Maxie
    datatype outcome = Winner of player | Draw
    datatype status = Over of outcome | In_play

    datatype position = Filled of player | Empty

    datatype c4state = S of (position Matrix.matrix) * player (* (0,0) is bottom-left corner *)
    type state = c4state

    type move = int (* cols are numbered 0 ... num_cols-1 *)

    fun move_to_string i = Int.toString i

    val pos_to_string = (fn Filled Minnie => "O"
                          | Filled Maxie => "X"
                          | Empty => " ")

    fun state_to_string (board as (S (m, _))) =
        let
          val rows = Matrix.rows m

          val ts : string Seq.seq -> string = Seq.reduce op^ ""

          fun print_row s = "|" ^ ts (Seq.map (fn x => pos_to_string x ^ "|") s) ^ "\n"
        in
            " " ^ ts (Seq.tabulate (fn i => "" ^ Int.toString i ^ " ") Dim.num_cols) ^ "\n" ^
            "-" ^ ts (Seq.tabulate (fn _ => "--") Dim.num_cols) ^ "\n" ^
            Seq.mapreduce print_row "" (fn (x,y) => y^x) rows ^ "\n"
        end
 
    fun lowestFreeRow (S (m, _) : state) (i : int (* column *)) : int option =
        let
            val filt = fn p : position => case p of
                                           Empty => false
                                         | _ => true

            val col = Seq.nth (Matrix.cols m) i

            val row = Seq.length (Seq.filter (filt) col)
        in
            case (Int.intEq (Dim.num_rows, row)) of
              true => NONE
            | false => SOME row
        end

    fun parse_move st input =
        case Int.fromString input of
            SOME i => (case (i < Dim.num_cols) of
                           true => (case (lowestFreeRow st i) of (* make sure there is a free spot in the column *)
                                        (SOME _) => SOME i

    (*START HERE*)
    val moves : state -> move Seq.seq (* assumes state is not Over; 
                                         generates moves that are valid in that state; 
                                         always generates at least one move *)
    fun status (S (m,_) state) : status =
        
    fun player (S (_,p) : state) : player = p
    (* initial state and transitions: *)
    val start : state = S (tabulate (fn _ => (tabulate (fn _ => Empty) (Dim.num_rows)) (Dim.num_cols)), Maxie)
    val make_move : (state * move) -> state (* assumes move is valid in that state *)
    (* The sign of a guess is absolute, rather than relative to whose turn it is: 
       negative values are better for Minnie       
       and positive values are better for Maxie. *)
    datatype est = Definitely of outcome | Guess of int
    (* estimate the value of the state, which is assumed to be In_play *)
    val estimate : state -> est
