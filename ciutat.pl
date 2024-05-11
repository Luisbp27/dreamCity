% Pràctca PROLOG
% Assignatura: Llenguatges de Programació
% Grau en Enginyeria Informàtica - Universitat de le Illes Balears
% Autors: Eduardo Bonnín Narváez i Lluis Barca Pons

% Definició de la estructura bàsica de la ciutat
ciutats(Nord, Est, Sud, Oest, Ciutat) :-
    length(Ciutat, 4),
    maplist(comprovar_longitud(4), Ciutat),
    maplist(permutation([1, 2, 3, 4]), Ciutat),
    transpose(Ciutat, CiutatT),
    maplist(permutation([1, 2, 3, 4]), CiutatT),
    maplist(comprovar_vista(Nord), Ciutat),
    maplist(comprovar_vista(Sud), CiutatT),
    reverse(CiutatT, CiutatRev),
    maplist(comprovar_vista(Est), CiutatRev),
    reverse(Ciutat, CiutatRev),
    maplist(comprovar_vista(Oest), CiutatRev),
    imprimir_ciutat(Ciutat).

% Assegurar la longitud especifica de les llistes
comprovar_longitud(Length, List) :-
    length(List, Length).

% Comprovar la visibilitat des de un costat
comprovar_vista(Vista, Edificis) :-
    edificis_visibles(Edificis, Visible),
    Vista = Visible.

% Contar els edificis visibles
edificis_visibles(Edificis, Contador) :-
    foldl(comprovar_altura, Edificis, (0, 0), (_, Contador)).

% Comprovar la altura dels edificis
comprovar_altura(Edifici, (AlturaAnterior, ContadorAnterior), (AlturaActual, ContadorActual)) :-
    Edifici > AlturaAnterior,
    AlturaActual = Edifici,
    ContadorActual is ContadorAnterior + 1.

% Transposar una matriu
transpose([], []).
transpose([F|Fs], Ts) :-
    transpose(F, [F|Fs], Ts).

transpose([], _, []).
transpose([_|Rs], Ms, [Ts|Tss]) :-
    llista_primers_restants(Ms, Ts, Ms1),
    transpose(Rs, Ms1, Tss).

llista_primers_restants([], [], []).
llista_primers_restants([[F|Os]|Rest], [F|Fs], [Os|Oss]) :-
    llista_primers_restants(Rest, Fs, Oss).

% Imprimir la ciutat
imprimir_ciutat(Ciutat) :-
    maplist(imprimir_fila, Ciutat).

% Imprimir una fila
imprimir_fila(Fila) :-
    maplist(write, Fila),
    nl.