/* distintos paises */
paisContinente(americaDelSur, argentina).
paisContinente(americaDelSur, bolivia).
paisContinente(americaDelSur, brasil).
paisContinente(americaDelSur, chile).
paisContinente(americaDelSur, ecuador).
paisContinente(europa, alemania).
paisContinente(europa, espania).
paisContinente(europa, francia).
paisContinente(europa, inglaterra).
paisContinente(asia, aral).
paisContinente(asia, china).
paisContinente(asia, gobi).
paisContinente(asia, india).
paisContinente(asia, iran).

/*países importantes*/
paisImportante(argentina).
paisImportante(kamchatka).
paisImportante(alemania).

/*países limítrofes*/
limitrofes([argentina,brasil]).
limitrofes([bolivia,brasil]).
limitrofes([bolivia,argentina]).
limitrofes([argentina,chile]).
limitrofes([espania,francia]).
limitrofes([alemania,francia]).
limitrofes([nepal,india]).
limitrofes([china,india]).
limitrofes([nepal,china]).
limitrofes([afganistan,china]).
limitrofes([iran,afganistan]).

/*distribucion en el tablero */
ocupa(argentina, azul, 4).
ocupa(bolivia, rojo, 1).
ocupa(brasil, verde, 4).
ocupa(chile, negro, 3).
ocupa(ecuador, rojo, 2).
ocupa(alemania, azul, 3).
ocupa(espania, azul, 1).
ocupa(francia, azul, 1).
ocupa(inglaterra, azul, 2). 
ocupa(aral, negro, 2).
ocupa(china, verde, 1).
ocupa(gobi, verde, 2).
ocupa(india, rojo, 3).
ocupa(iran, verde, 1).

ocupa(Pais, Jugador):- ocupa(Pais, Jugador, _).

/*continentes*/
continente(americaDelSur).
continente(europa).
continente(asia).

/*objetivos*/
objetivo(rojo, ocuparContinente(asia)).
objetivo(azul, ocuparPaises([argentina, bolivia, francia, inglaterra, china])).
objetivo(verde, destruirJugador(rojo)).
objetivo(negro, ocuparContinente(europa)).

% 1 ------------------------------------------------------------
%estaEnContinente/2 relacion jugador con continente
estaEnContinente(Jugador, Continente):-
    paisContinente(Continente, Pais),
    ocupa(Pais, Jugador).

% 2 ------------------------------------------------------------
cantidadPaises(Jugador, CantidadPaises):-
    objetivo(Jugador, _),
    findall(Pais, ocupa(Pais, Jugador), Paises),
    length(Paises, CantidadPaises).

% 3 ------------------------------------------------------------
% ocupaContinente/2: Relaciona un jugador y un continente si el jugador ocupa totalmente al continente.
ocupaContinente(Jugador, Continente):-
    estaEnContinente(Jugador, Continente),
    not((estaEnContinente(Jugador2, Continente), Jugador2 \= Jugador)).

ocupaContinente2(Jugador, Continente):-
    objetivo(Jugador, _),
    continente(Continente),
    forall(paisContinente(Continente, Pais), ocupa(Pais, Jugador)).

% 4 ------------------------------------------------------------
%leFaltaMucho/2: Relaciona a un jugador y un continente si al jugador le falta ocupar más de 2 países de dicho continente.
leFaltaMucho(Jugador, Continente):-
    objetivo(Jugador, _),
    continente(Continente),
    findall(Pais, (paisContinente(Continente, Pais), not(ocupa(Pais, Jugador))), Paises),
    length(Paises, CantidadPaises),
    CantidadPaises > 2.

% 5 ------------------------------------------------------------
% sonLimitrofes/2: Relaciona 2 países si son limítrofes.
sonLimitrofes(Pais1, Pais2):-
    limitrofes(Paises),
    member(Pais1, Paises),
    member(Pais2, Paises),
    Pais1 \= Pais2.

% 6 ------------------------------------------------------------
% esGroso/1: Un jugador es groso si cumple algunas de estas condiciones:
% a) ocupa todos los países importantes,
% b) ocupa más de 10 países
% c) o tiene más de 50 ejercitos.
esGroso(Jugador):-
    jugador(Jugador),
    forall(paisImportante(Pais), ocupa(Pais, Jugador)).
esGroso(Jugador):-
    cantidadPaises(Jugador, Cantidad),
    Cantidad > 10.
esGroso(Jugador):-
    jugador(Jugador),
    forall(paisImportante(Pais), ocupa(Pais, Jugador)).
esGroso(Jugador):-
    findall(Pais, ocupa(Pais, Jugador), Paises),
    maplist(ejercitosEn, Paises, Cantidades), % no le agrego los parámetros a "ejercitosEn" porque dentro del map_list hago "call(ejercitosEn, Pais, Cantidad)"
    sum_list(Cantidades, Total),
    Total > 50.

jugador(Jugador):-
    objetivo(Jugador, _).

ejercitosEn(Paises, Cantidad):-
    ocupa(Paises, _, Cantidad).

% 7 ------------------------------------------------------------
% estaEnElHorno/1: un país está en el horno si todos sus países limítrofes están ocupados por el mismo jugador que no es el mismo que ocupa ese país.
estaEnElHorno(Pais):-
    ocupa(Pais, Jugador1),
    jugador(Jugador2),
    Jugador1 \= Jugador2,
    forall(sonLimitrofes(Pais, Limitrofe), ocupa(Limitrofe, Jugador2)).

% 8 ------------------------------------------------------------
% esCaotico/1: un continente es caótico si hay más de tres jugadores en el.

% 9 ------------------------------------------------------------
% capoCannoniere/1: es el jugador que tiene ocupado más países.

% 10 ------------------------------------------------------------
% ganadooor/1: un jugador es ganador si logro su objetivo 
ganadooor(Jugador):-
    objetivo(Jugador, Objetivo),
    cumple(Jugador, Objetivo).

cumple(Jugador, ocuparContinente(Continente)):-
    ocupaContinente(Jugador, Continente).
cumple(Jugador, ocuparPaises(Paises)):-
    forall(member(Pais, Paises), ocupa(Pais, Jugador)).
cumple(Jugador, destruirJugador(OtroJugador)):-
    not(ocupa(_, OtroJugador)).