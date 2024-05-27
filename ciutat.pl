permutation([], []).
permutation(L, [H|T]) :- append(V, [H|U], L), append(V, U, W), permutation(W, T).


visible([], 0).
visible([H|T], Count) :-
    visible(T, CT),
    check_visibility(H, T, CT, Count).

check_visibility(_, _, CT, CT).
check_visibility(H, T, CT, Count) :- max_in_list(T, Max), H > Max, Count is CT + 1.

max_in_list([H|T], Max) :- foldl(max, T, H, Max).
max(X, Y, Z) :- Z is max(X, Y).


validate_visibility(Matrix, West, East, North, South) :-
    maplist(visible_from_west, Matrix, West),
    maplist(visible_from_east, Matrix, East),
    transpose(Matrix, Transposed),
    maplist(visible_from_north, Transposed, North),
    maplist(visible_from_south, Transposed, South).


ciutats(West, East, North, South, [F1, F2, F3, F4]) :-
    maplist(permutation([1, 2, 3, 4]), [F1, F2, F3, F4]),
    transpose([F1, F2, F3, F4], [C1, C2, C3, C4]),
    maplist(permutation([1, 2, 3, 4]), [C1, C2, C3, C4]),
    validate_visibility([F1, F2, F3, F4], West, East, North, South).


transpose([], []).
transpose([[]|_], []) :- !.
transpose(Matrix, [Row|Rows]) :-
    transpose_column(Matrix, Row, RestMatrix),
    transpose(RestMatrix, Rows).

transpose_column([], [], []).
transpose_column([[H|T]|Rows], [H|Hs], [T|Ts]) :-
    transpose_column(Rows, Hs, Ts).

% Cuenta cuántos edificios pueden ser vistos desde el inicio de una lista (fila o columna)
visible_count([First|Rest], Visible) :-
    visible_count_helper(Rest, First, 1, Visible).

visible_count_helper([], _, Count, Count).
visible_count_helper([H|T], MaxSoFar, CountSoFar, Visible) :-
    (   H > MaxSoFar
    ->  NewCount is CountSoFar + 1,
        visible_count_helper(T, H, NewCount, Visible)
    ;   visible_count_helper(T, MaxSoFar, CountSoFar, Visible)
    ).

% Especifico para la visibilidad desde el oeste (izquierda a derecha)
visible_from_west(Row, Visible) :-
    visible_count(Row, Visible).

% Especifico para la visibilidad desde el este (derecha a izquierda)
visible_from_east(Row, Visible) :-
    reverse(Row, Reversed),
    visible_count(Reversed, Visible).

% Especifico para la visibilidad desde el norte (arriba hacia abajo)
visible_from_north(Column, Visible) :-
    visible_count(Column, Visible).

% Especifico para la visibilidad desde el sur (abajo hacia arriba)
visible_from_south(Column, Visible) :-
    reverse(Column, Reversed),
    visible_count(Reversed, Visible).