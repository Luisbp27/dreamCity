invierte(Lista, Invertida) :-
    invierte_aux(Lista, [], Invertida).

invierte_aux([], Invertida, Invertida).
invierte_aux([H|T], Acum, Invertida) :-
    invierte_aux(T, [H|Acum], Invertida).

% Este predicado genera una matriz, calcula la visibilidad desde todas las direcciones,
% y luego muestra esos resultados.
calcular_y_mostrar_visibilidad(Matriz) :-
    calcular_visibilidad(Matriz, VisOeste, VisEste, VisNorte, VisSur),  % Calcula la visibilidad.

    % Imprimir los resultados de visibilidad.
    writeln('Matriz Generada:'),
    imprimir_matriz(Matriz),
    writeln('Visibilidad Oeste (por fila): '), writeln(VisOeste),
    writeln('Visibilidad Este (por fila): '), writeln(VisEste),
    writeln('Visibilidad Norte (por columna): '), writeln(VisNorte),
    writeln('Visibilidad Sur (por columna): '), writeln(VisSur).

% Auxiliar para imprimir la matriz
imprimir_matriz([]).
imprimir_matriz([Fila|Resto]) :-
    writeln(Fila),
    imprimir_matriz(Resto).