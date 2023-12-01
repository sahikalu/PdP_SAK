:- include(travelingPokeManGoProblem).

:- begin_tests(mejorTour). % Hay 2 mejores tours ya que ir o volver por cada camino es igual

/* Si representaron las etapas del tour de otra forma, ajustar el test a dicha forma */
test("El mejor camino es shopping, teatro, plaza, congreso, cementerio", nondet):- 
    mejorTour(50, [abasto_shopping, teatro_colon, plaza_de_mayo, congreso, cementerio_recoleta]).

test("El mejor camino es cementerio, congreso, plaza, teatro, shopping", nondet):-
    mejorTour(50, [cementerio_recoleta, congreso, plaza_de_mayo, teatro_colon, abasto_shopping]).

:- end_tests(mejorTour).

:- begin_tests(estaSitiado).

/* Congreso es de un color y sus vecionos son de otro e iguales entre sí, ya que no está conectado por un camino con el Shopping. Está sitiado. */
test("El Gym del Congreso está sitiado", nondet):-
    estaSitiado(congreso).

/* Plaza de Mayo tiene vecinos del mismo color, no está sitiado. */
test("El Gym de Plaza de Mayo no está sitiado", fail):-
    estaSitiado(plaza_de_mayo).

:- end_tests(estaSitiado).