/*
ocupaContinente(Jugador, Continente):-
    objetivo(Jugador, _), % resuelvo cuando la incógnita es el jugador
    continente(Continente),  % resuelvo cuando la incógnita es el continente
    forall(paisContinente(Continente, Pais), ocupa(Pais, Jugador)). % la primera parte (antes de la coma) es consulta existencial y la segunda (después de la coma) es consulta individual
*/


% 1 pedepin = $1000
% corte(carne, pedepines).
corte(asado, 2).
corte(vacio, 2.5).
corte(chori, 1).
corte(molleja, 4).
corte(chinchu, 2).
corte(asado, 2).
corte(bondiola, 2).
corte(matambrito, 2.5).
corte(entrania, 4).

% 8 pedepines máximo
presupuesto(8).

asado(Cortes):-
    presupuesto(Presu),
    compra(Presu, Cortes),
    Cortes \= [].

compra(_, []).
compra(Presu, [Corte | Cortes]):-
    corte(Corte, Precio),
    Precio =< Presu,
    Resto is Presu - Precio,
    compra(Resto, Cortes).

platoCopado(Cortes):-
    findall(Corte, corte(Corte, _), TodosLosCortes),
    subConjunto(TodosLosCortes, Cortes),
    length(Cortes, Cant),
    Cant >= 3.

% Sublista respetando el orden de los elementos
subConjunto(_, []).
subConjunto(Conjunto, [H | T]):-
    select(H, Conjunto, Resto),
    subConjunto(Resto, T).


platoCopadoKosher(Cortes):-
    platoCopado(Cortes),
    forall(member(Corte, Cortes), esKosher(Corte)).

esKosher(Corte):-
    not(member(Corte, [bondiola, matambrito, chori])).

filter(_, [], []). % si no tengo elementos que cumplan la condicion, lista vacía
filter(Condicion,[H | T],[H | OT]):- % si tengo elementos que cumplan la condicion, la lista lo incluye
    call(Condicion, H),
    filter(Condicion, T, OT).
filter(Condicion,[H | T], OT):- % si no tengo elementos que cumplan la condicion, la lista NO lo incluye
    not(call(Condicion, H)),
    filter(Condicion, T, OT).

platoKosher(Kortes):-
    platoCopado(Cortes),
    filter(esKosher, Cortes, Kortes).