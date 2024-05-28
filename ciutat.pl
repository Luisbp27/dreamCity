permuta([],[]).
permuta([X|Y],Z) :- permuta(Y,L),
                    insereix(X,L,Z).

insereix(E,L,[E|L]).
insereix(E,[X|Y],[X|Z]) :- insereix(E,Y,Z).

invertir([X],[X]).
invertir([X|L1],L2) :- invertir(L1,L3),
                        afegir(L3,[X],L2).

afegir([],L,L).
afegir([X|L1],L2,[X|L3]) :- afegir(L1,L2,L3).

% Genera todas las matrices posibles que cumplen con la restricción de fila
generar_matrices(Matriz) :-
    permuta([1, 2, 3, 4], F1),
    permuta([1, 2, 3, 4], F2),
    permuta([1, 2, 3, 4], F3),
    permuta([1, 2, 3, 4], F4),
    Matriz = [F1, F2, F3, F4],
    columnas_validas(Matriz).

% Verifica que las columnas de la matriz cumplan también la restricción
columnas_validas([[A1, B1, C1, D1], [A2, B2, C2, D2], [A3, B3, C3, D3], [A4, B4, C4, D4]]) :-
    permuta([1, 2, 3, 4], [A1, A2, A3, A4]),
    permuta([1, 2, 3, 4], [B1, B2, B3, B4]),
    permuta([1, 2, 3, 4], [C1, C2, C3, C4]),
    permuta([1, 2, 3, 4], [D1, D2, D3, D4]).


% Cuenta cuántos edificios son visibles desde el principio de la lista
visibles(Lista, Cantidad) :-
    visibles_aux(Lista, 0, 0, Cantidad).

% visibles_aux(Lista, MaxAltura, Acumulador, Cantidad)
visibles_aux([], _, Contador, Contador).
visibles_aux([Altura|Resto], MaxAltura, Acumulador, Cantidad) :-
    (Altura > MaxAltura -> 
        NuevoAcum is Acumulador + 1,
        visibles_aux(Resto, Altura, NuevoAcum, Cantidad)
    ;
        visibles_aux(Resto, MaxAltura, Acumulador, Cantidad)
    ).


% Extrae la N-ésima columna de una lista de listas (matriz)
extraer_columna([], _, []).
extraer_columna([Fila|Resto], N, [Elem|Columna]) :-
    nth1(N, Fila, Elem),
    extraer_columna(Resto, N, Columna).


% Calcular visibilidad para todas las filas & columnas en el orden: Oeste, Este, Norte, Sur
calcular_visibilidad(Matriz, VisOeste, VisEste, VisNorte, VisSur) :-
    calcular_visibilidad_filas(Matriz, VisOeste, VisEste),
    calcular_visibilidad_columnas(Matriz, VisNorte, VisSur).

% Calcular visibilidad para las filas.
calcular_visibilidad_filas([], [], []).
calcular_visibilidad_filas([Fila|Resto], [VisOeste|RestoOeste], [VisEste|RestoEste]) :-
    visibles(Fila, VisOeste),
    invertir(Fila, FilaInvertida),
    visibles(FilaInvertida, VisEste),
    calcular_visibilidad_filas(Resto, RestoOeste, RestoEste).

% Calcular visibilidad para las columnas.
calcular_visibilidad_columnas(Matriz, VisNorte, VisSur) :-
    calcular_visibilidad_columnas(Matriz, VisNorte, VisSur, 1).

calcular_visibilidad_columnas(_, [], [], 5) :- !.  % Suponemos que la matriz es 4x4.
calcular_visibilidad_columnas(Matriz, [VisNorte|RestoNorte], [VisSur|RestoSur], N) :-
    extraer_columna(Matriz, N, Columna),
    visibles(Columna, VisNorte),
    invertir(Columna, ColumnaInvertida),
    visibles(ColumnaInvertida, VisSur),
    N1 is N + 1,
    calcular_visibilidad_columnas(Matriz, RestoNorte, RestoSur, N1).


% Comprueba si la matriz generada cumple con las visibilidades dadas
ciutats(VisOeste, VisEste, VisNorte, VisSur, Matriz) :-
    generar_matrices(Matriz),  % Genera la matriz.
    calcular_visibilidad(Matriz, CalculadoOeste, CalculadoEste, CalculadoNorte, CalculadoSur),
    % Compara las visibilidades calculadas con las proporcionadas
    VisOeste == CalculadoOeste,
    VisEste == CalculadoEste,
    VisNorte == CalculadoNorte,
    VisSur == CalculadoSur.