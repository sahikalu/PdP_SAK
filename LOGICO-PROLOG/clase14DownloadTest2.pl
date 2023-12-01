:- include(clase14Download).

:- begin_tests(tituloDelContenido).

test("Relación libro con título"):-
    titulo(libro(fundation, asimov, 3), fundation).

test("Relación musica con título", fail):-
    titulo(musica(theLastHero, hardRock, alterBridge), theFirstHero).

:- end_tests(tituloDelContenido).

:- begin_tests(descargaDelContenido).

test("Descarga el contenido de un usuario", nondet):-
    descargaDelContenido(mati1009, serie(strangerThings, [thriller, fantasia])).

test("Descarga el contenido de un usuario", set(Contenido = [serie(strangerThings, [thriller, fantasia]),pelicula(infinityWar, accion, 2018)])):-
    descargaDelContenido(mati1009, Contenido).

:- end_tests(descargaDelContenido).
