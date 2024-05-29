% Práctica PROLOG
% Asignatura: Llenguatges de Programació
% Grau en Enginyeria Informàtica - Universitat de les Illes Balears
% Autores: Eduardo Bonnín Narváez i Lluis Barca Pons (Grupo de Trabajo 3)

% Genera todas las matrices posibles que cumplen con la restricción de fila y verifica visibilidad preliminar
generar_matrices(Matriz, VisOesteEsperado, VisEsteEsperado) :-
    permuta([1, 2, 3, 4], F1), visibles(F1, V1Oeste), invertir(F1, F1Inv), visibles(F1Inv, V1Este),
    permuta([1, 2, 3, 4], F2), visibles(F2, V2Oeste), invertir(F2, F2Inv), visibles(F2Inv, V2Este),
    permuta([1, 2, 3, 4], F3), visibles(F3, V3Oeste), invertir(F3, F3Inv), visibles(F3Inv, V3Este),
    permuta([1, 2, 3, 4], F4), visibles(F4, V4Oeste), invertir(F4, F4Inv), visibles(F4Inv, V4Este),
    Matriz = [F1, F2, F3, F4],
    columnas_validas(Matriz),
    VisOesteEsperado = [V1Oeste, V2Oeste, V3Oeste, V4Oeste],
    VisEsteEsperado = [V1Este, V2Este, V3Este, V4Este].

% Verifica que las columnas de la matriz también cumplan la restricción
columnas_validas([[A1, B1, C1, D1], [A2, B2, C2, D2], [A3, B3, C3, D3], [A4, B4, C4, D4]]) :-
    permuta([1, 2, 3, 4], [A1, A2, A3, A4]),
    permuta([1, 2, 3, 4], [B1, B2, B3, B4]),
    permuta([1, 2, 3, 4], [C1, C2, C3, C4]),
    permuta([1, 2, 3, 4], [D1, D2, D3, D4]).


% Cuenta cuántos edificios son visibles desde el principio de la lista
visibles(Lista, Cantidad) :-
    visibles_aux(Lista, 0, 0, Cantidad).

% Cuando la lista está vacía
visibles_aux([], _, Contador, Contador).

% Cuando el elemento actual es mayor que el máximo visto hasta ahora
visibles_aux([Altura|Resto], MaxAltura, Acumulador, Cantidad) :-
    Altura > MaxAltura,
    NuevoAcum is Acumulador + 1,
    visibles_aux(Resto, Altura, NuevoAcum, Cantidad).

% Cuando el elemento actual no es mayor que el máximo visto hasta ahora
visibles_aux([Altura|Resto], MaxAltura, Acumulador, Cantidad) :-
    Altura =< MaxAltura,
    visibles_aux(Resto, MaxAltura, Acumulador, Cantidad).

% Columnas
calcular_visibilidad_columnas(Matriz, VisNorte, VisSur) :-
    calcular_visibilidad_columnas(Matriz, VisNorte, VisSur, 1).

calcular_visibilidad_columnas(_, [], [], 5) :- !.  % (Matriz 4x4)
calcular_visibilidad_columnas(Matriz, [VisNorte|RestoNorte], [VisSur|RestoSur], N) :-
    extraer_columna(Matriz, N, Columna),
    visibles(Columna, VisNorte),
    invertir(Columna, ColumnaInvertida),
    visibles(ColumnaInvertida, VisSur),
    N1 is N + 1,
    calcular_visibilidad_columnas(Matriz, RestoNorte, RestoSur, N1).


% Método principal que comprueba si la matriz generada cumple con las visibilidades dadas
ciutats(VisOeste, VisEste, VisNorte, VisSur, Matriz) :-
    generar_matrices(Matriz, VisOeste, VisEste),
    calcular_visibilidad_columnas(Matriz, VisNorte, VisSur).
    % Compara las visibilidades calculadas con las proporcionadas
    VisOeste = CalculadoOeste,
    VisEste = CalculadoEste,
    VisNorte = CalculadoNorte,
    VisSur = CalculadoSur.


% MÉTODOS AUXILIARES

permuta([],[]).
permuta([X|Y],Z) :-
    permuta(Y,L),insereix(X,L,Z).

insereix(E,L,[E|L]).
insereix(E,[X|Y],[X|Z]) :-
    insereix(E,Y,Z).

invertir([X],[X]).
invertir([X|L1],L2) :-
    invertir(L1,L3),afegir(L3,[X],L2).

afegir([],L,L).
    afegir([X|L1],L2,[X|L3]) :- afegir(L1,L2,L3).

% Extrae la N-ésima columna de una lista de listas (matriz)
extraer_columna([], _, []).
extraer_columna([Fila|Resto], N, [Elem|Columna]) :-
    nth1(N, Fila, Elem), extraer_columna(Resto, N, Columna).