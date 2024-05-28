permutation([], []).
permutation(L, [H|T]) :- append(V, [H|U], L), append(V, U, W), permutation(W, T).


visible([], 0).
visible([H|T], Count) :-
    visible(T, CT),
    (   CT = 0 -> Count is 1
    ;   check_visibility(H, T, CT, Count)).

check_visibility(_, [], CT, CT).
check_visibility(H, [H2|_], CT, Count) :- H > H2, Count is CT + 1.
check_visibility(H, [H2|_], CT, CT) :- H =< H2.


validate_visibility(Matrix, West, East, North, South) :-
    maplist(visible_from_west, Matrix, West),
    maplist(visible_from_east, Matrix, East),
    transpose(Matrix, Transposed),
    maplist(visible_from_north, Transposed, North),
    maplist(visible_from_south, Transposed, South),
    !. % Corte para evitar retroceso una vez validado


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
    visible_count_helper(Rest, First, 1, Visible),
    write('Checking visibility for row/column: '), writeln([First|Rest]),
    write('Visible buildings: '), writeln(Visible).


visible_count_helper([], MaxSoFar, Count, Count) :-
    write('End of row/column, max seen so far: '), write(MaxSoFar),
    write(', total visible: '), writeln(Count).
visible_count_helper([H|T], MaxSoFar, CountSoFar, Visible) :-
    (   H > MaxSoFar
    ->  NewCount is CountSoFar + 1,
        write('New building visible, height: '), write(H),
        write(', new count: '), writeln(NewCount),
        visible_count_helper(T, H, NewCount, Visible)
    ;   visible_count_helper(T, MaxSoFar, CountSoFar, Visible),
        write('Building not visible, height: '), write(H),
        write(', current max: '), write(MaxSoFar),
        write(', current count: '), writeln(CountSoFar)
    ).


visible_from_west(Row, Visible) :-
    visible_count(Row, Visible),
    write('Visible from west: '), write(Row),
    write(' -> '), writeln(Visible).

visible_from_east(Row, Visible) :-
    reverse(Row, Reversed),
    visible_count(Reversed, Visible),
    write('Visible from east: '), write(Row),
    write(' -> '), writeln(Visible).

visible_from_north(Column, Visible) :-
    visible_count(Column, Visible),
    write('Visible from north: '), write(Column),
    write(' -> '), writeln(Visible).

visible_from_south(Column, Visible) :-
    reverse(Column, Reversed),
    visible_count(Reversed, Visible),
    write('Visible from south: '), write(Column),
    write(' -> '), writeln(Visible).