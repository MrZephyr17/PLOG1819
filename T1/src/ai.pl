:- consult('logic.pl').

not(X):- X, !, fail.
not(_X).

siga(_Board, _Level, [_], _BestVal, _BestMove).

siga(Board, Level, [Move | Rest], BestVal, BestMove):-
    move(Move, Board, _NewBoard),
    minimax(Board, Level, false, MoveVal),
    (
        MoveVal > BestVal, 
        (
            BestMove is Move,
            BestVal is MoveVal
        )
    ),
    write('Foda-se'),

    siga(Board, Level, Rest, BestVal, BestMove).

findBestMove(Board, Level, ValidMoves, BestMove):-
    BestVal is -1000,
    write('Foda-se'),
    siga(Board, Level, ValidMoves, BestVal, BestMove).

maxBestMove(_Best, _Board, _Level, _IsMax, [_]).

maxBestMove(Best, Board, Level, IsMax, [Move | Rest]):-
    move(Move, Board, NewBoard),
    minimax(NewBoard,Level,not(IsMax),TempBest),
    NewBest is max(Best, TempBest),
    maxBestMove(NewBest, NewBoard, Level, IsMax, Rest).


minBestMove(_Best, _Board, _Level, _IsMax, [_Move | _]).

minBestMove(Best, Board, Level, IsMax, [Move | Rest]):-
    move(Move, Board, NewBoard),
    minimax(NewBoard,Level,not(IsMax),TempBest),
    NewBest is min(Best, TempBest),
    minBestMove(NewBest, NewBoard, Level, IsMax, Rest).

minimax(_Board, 1, _IsMax, _BestVal).

minimax(Board, Level, IsMax, BestVal):-
    value(Board, _Player, Value),
    (Value \= 1, BestVal is Value);
    (
        NewLevel is Level - 1,
        (IsMax,
         Best is -1000,
         valid_moves(Board, black, ValidMoves),
         maxBestMove(Best, Board, NewLevel, IsMax, ValidMoves),
         BestVal is Best
        )
        ;
        (
        Best is 1000,
        valid_moves(Board, white, ValidMoves),
        minBestMove(Best, Board, NewLevel, IsMax, ValidMoves),
        BestVal is Best
        )     
    ).

/**
 * Return value for the current state of the game. Used by minimax.
 */ 
value(Board, _Player, Value):-
    game_over(Board, Winner),
    winner(Winner, Value).

/**
 * Return the value for the winner of the game.
 */ 
winner(black, Value) :-
    Value=10.
winner(white, Value):- 
    Value = -10.
winner(none, Value):- 
    Value = 1.
winner(draw, Value):- 
    Value = 0.

choose_move(Board, Level, Move):-
    valid_moves(Board, white, ValidMoves),
    write('Foda-se\n'),
    findBestMove(Board,Level,ValidMoves,Move).
