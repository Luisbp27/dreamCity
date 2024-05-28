% Predicado principal
% ciutats(Oest, Est, Nord, Sud, Solució)
ciutats(Oest, Est, Nord, Sud, [F1, F2, F3, F4]) :-
    % Definir las filas de la ciudad
    F1 = [A1, A2, A3, A4],
    F2 = [B1, B2, B3, B4],
    F3 = [C1, C2, C3, C4],
    F4 = [D1, D2, D3, D4],

    % Agrupar filas en la solución
    Solució = [F1, F2, F3, F4],

    % Cada fila debe contener los números 1, 2, 3 y 4 exactamente una vez
    fila_valida(F1), fila_valida(F2), fila_valida(F3), fila_valida(F4),

    % Cada columna debe contener los números 1, 2, 3 y 4 exactamente una vez
    columna_valida([A1, B1, C1, D1]),
    columna_valida([A2, B2, C2, D2]),
    columna_valida([A3, B3, C3, D3]),
    columna_valida([A4, B4, C4, D4]),

    % Verificar restricciones de visibilidad
    visibilidad(Oest, Est, Nord, Sud, Solució).

% Una fila o columna es válida si contiene los números 1, 2, 3 y 4 exactamente una vez
fila_valida(Fila) :-
    permutation([1, 2, 3, 4], Fila).

columna_valida(Columna) :-
    permutation([1, 2, 3, 4], Columna).

% Verificar restricciones de visibilidad
visibilidad(Oest, Est, Nord, Sud, Ciudad) :-
    visibilidad_oest(Oest, Ciudad),
    visibilidad_est(Est, Ciudad),
    visibilidad_nord(Nord, Ciudad),
    visibilidad_sud(Sud, Ciudad).

% Visibilidad desde el oeste
visibilidad_oest([], []).
visibilidad_oest([O|Os], [Fila|Filas]) :-
    visible_desde_izquierda(O, Fila),
    visibilidad_oest(Os, Filas).

% Visibilidad desde el este
visibilidad_est([], []).
visibilidad_est([E|Es], [Fila|Filas]) :-
    reverse(Fila, FilaReversa),
    visible_desde_izquierda(E, FilaReversa),
    visibilidad_est(Es, Filas).

% Visibilidad desde el norte
visibilidad_nord([], []).
visibilidad_nord([N|Ns], Ciudad) :-
    nth_column(Ciudad, N, Columna),
    visible_desde_izquierda(N, Columna),
    visibilidad_nord(Ns, Ciudad).

% Visibilidad desde el sur
visibilidad_sud([], []).
visibilidad_sud([S|Ss], Ciudad) :-
    nth_column(Ciudad, S, Columna),
    reverse(Columna, ColumnaReversa),
    visible_desde_izquierda(S, ColumnaReversa),
    visibilidad_sud(Ss, Ciudad).

% Obtener la n-ésima columna de una matriz
nth_column([Fila|_], 1, Columna) :-
    Columna = [Fila].
nth_column([_|Filas], N, Columna) :-
    N > 1,
    N1 is N - 1,
    nth_column(Filas, N1, Columna).

% Contar edificios visibles desde la izquierda
visible_desde_izquierda(Visible, Fila) :-
    contar_visibles(Fila, 0, 0, Visible).

contar_visibles([], _, Visibles, Visibles).
contar_visibles([H|T], Max, Contador, Visibles) :-
    (H > Max -> NewMax is H, NewContador is Contador + 1; NewMax is Max, NewContador is Contador),
    contar_visibles(T, NewMax, NewContador, Visibles).