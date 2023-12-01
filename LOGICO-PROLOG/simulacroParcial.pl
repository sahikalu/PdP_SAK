% camino(GymA, GymB, DuracionViajeMin, CantidadPokeparadas).
camino(plaza_de_mayo, congreso, 9, 15).
camino(plaza_de_mayo, teatro_colon, 11, 15).
camino(plaza_de_mayo, abasto_shopping, 19, 28).
camino(plaza_de_mayo, cementerio_recoleta, 26, 36).
camino(congreso, teatro_colon, 10, 11).
camino(congreso, cementerio_recoleta, 15, 16).
camino(teatro_colon, abasto_shopping, 13, 20).
camino(teatro_colon, cementerio_recoleta, 17, 24).
camino(abasto_shopping, cementerio_recoleta, 27, 32).

/*
1) ¿Qué representa “una etapa” o elemento en el tour? Hay dos enfoques posibles principales:
a) Cada etapa es un nuevo gimnasio.
b) Cada etapa es un trayecto y se corresponde con un camino que conecta un gimnasio con otro.
Recomendamos que sea alguno de estos, pero si piensan en otro modelo también puede ser válido. Consultar.
*/

% Selecciono la opción a)Cada etapa es un nuevo gimnasio.

% 2) Tener en cuenta que, en un camino, no es necesario ir de un gimnasio A hacia otro B: bien se podría recorrer el trayecto en el sentido inverso, de B hacia A. Definir una abstracción que refleje lo anterior.

caminoNoDirigido(GymA, GymB, DuracionViajeMin, CantidadPokeparadas) :-
    camino(GymA, GymB, DuracionViajeMin, CantidadPokeparadas).
caminoNoDirigido(GymA, GymB, DuracionViajeMin, CantidadPokeparadas) :-
    camino(GymB, GymA, DuracionViajeMin, CantidadPokeparadas).

/*
3) Generar una secuencia de etapas que pasa por todos los gimnasios, sin repetir los mismos y sin exceder el límite de tiempo.
Tip: Puede ser más sencillo primero armar la secuencia y luego controlar el total, pero también puede hacerse todo junto.
*/

secuenciaEnTiempo(Gimnasios, TiempoTotal, PokeParadasEncontradas):-
    findall(Gym, gimnasio(Gym), Gyms),
    permutation(Gyms, Gimnasios),
    tour(Gimnasios, TiempoTotal, PokeParadasEncontradas),
    TiempoTranscurrido =< TiempoTotal.

gimnasio(Gym):-
    distinct(Gym, caminoNoDirigido(Gym, _, _, _)).

tour([_], 0, 0).
tour([GymA, GymB | Gyms], TiempoTour, PokeParadasTour):-
    caminoNoDirigido(GymA, GymB, DuracionViajeMin, CantidadPokeparadas),
    tour([GymB | Gyms], TiempoResto, PokeParadasResto),
    TiempoTour is TiempoTour + TiempoResto,
    PokeParadasTour is PokeParadasTour + PokeParadasResto.

% 4) Pueden ser útiles los predicados:
% a) permutation/2, el cual relaciona 2 listas cuando la segunda es una permutación de la primera. Este predicado es inversible para la segunda lista.
% b) list_to_set/2, que relaciona una lista con otra, si la segunda contiene los mismos elementos que la primera pero sin repeticiones de los mismos. Es inversible para la segunda lista y respeta el orden de aparición de los elementos (primera vez de c/u).

% 5) En base a esas consideraciones, implementar mejorTour/2, que debe cumplirse para aquella secuencia de pasos que maximice la cantidad de paradas en su trayecto, siempre dentro del límite de tiempo establecido. No necesita ser inversible para el límite de tiempo.
/**
* mejorTour/2 relaciona un tiempo límite con un tour que se puede hacer dentro del mismo.
* Debe ser inversible para el tour.
* */

% mejorTour(a,b).
mejorTour(Limite, Tour):-
    secuenciaEnTiempo(Tour, Limite, PokeParadas),
    not((secuenciaEnTiempo(_, Limite, PokeParadas2), PokeParadas2 > PokeParadas)).

/*
Ahora agregamos información: Un gimnasio está, en un determinado momento, ocupado por un equipo de un color (rojo, azul, amarillo). 
*/
% 6) Agregar está información a la base de conocimiento para todos los gimnasios anteriores, sin modificar lo realizado hasta ahora. El shopping tendrá un color, el Congreso otro, y los demás un tercero.

% color(Gym, Color).
color(plaza_de_mayo, rojo).
color(congreso, azul).
color(cementerio_recoleta, amarillo).
color(teatro_colon, amarillo).
color(plaza_de_mayo, amarillo).

% 7) Implementar estaSitiado/1. Un gimnasio está sitiado cuando todos sus vecinos están ocupados por equipos de un mismo color, que no es el mismo del equipo de ese gimnasio. Un gimnasio “vecino” es aquel conectado con un camino directamente, es decir, sin pasar por otros gimnasios en medio.
/**
* estaSitiado/1 se cumple (o no) para un gimnasio. 
* Debe ser inversible. 
* */

vecino(Gym, Vecino):-
    caminoNoDirigido(Gym, Vecino, _, _).

% estaSitiado(a).
estaSitiado(Gym):-
    color(Gym, Color),
    vecino(Gym, Vecino),
    color(Vecino, ColorVecino),
    Color \= ColorVecino,
    forall(vecino(Gym, Vecino2), color(Vecino2, ColorVecino)).