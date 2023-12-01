/*

Los dueños de distintas empresas de recursos requieren cierto análisis sobre la información de descargas, con el supuesto propósito de mejorar la calidad del servicio a sus clientes, que de acuerdo a nuestro entendimiento es solo para vender nuevos upgrades a los clientes de acuerdo a lo que consumen. 
Para esto nos brindaron una pequeña información de las descargas realizadas en este último tiempo, escritas en forma de cláusulas (¿quién lo hubiese dicho?) del predicado recurso/4, que relaciona: una empresa, nombre del servidor, peso en GBs del recurso y el recurso propiamente dicho, que puede ser libro, disco de música, serie o película:
*/

% libro(título, autor, edición)
recurso(amazingzone, host1, 0.1, libro(lordOfTheRings, jrrTolkien, 4)).
recurso(g00gle, ggle1, 0.04, libro(fundation, asimov, 3)).
recurso(g00gle, ggle1, 0.015, libro(estudioEnEscarlata, conanDoyle, 3)).

% musica(título, género, banda/artista)
recurso(spotify, spot1, 0.3, musica(theLastHero, hardRock, alterBridge)).
recurso(pandora, pand1, 0.3, musica(burn, hardRock, deepPurple)).
recurso(spotify, spot1, 0.3, musica(2, hardRock, blackCountryCommunion)).
recurso(spotify, spot2, 0.233, musica(squareUp, kpop, blackPink)).
recurso(pandora, pand1, 0.21, musica(exAct, kpop, exo)).
recurso(pandora, pand1, 0.28, musica(powerslave, heavyMetal, ironMaiden)).
recurso(spotify, spot4, 0.18, musica(whiteWind, kpop, mamamoo)).
recurso(spotify, spot2, 0.203, musica(shatterMe, dubstep, lindseyStirling)).
recurso(spotify, spot4, 0.22, musica(redMoon, kpop, mamamoo)).
recurso(g00gle, ggle1, 0.31, musica(braveNewWorld, heavyMetal, ironMaiden)).
recurso(pandora, pand1, 0.212, musica(loveYourself, kpop, bts)).
recurso(spotify, spot2, 0.1999, musica(aloneInTheCity, kpop, dreamcatcher)).

% serie(título, géneros)
recurso(netflix, netf1, 30, serie(strangerThings, [thriller, fantasia])).
recurso(fox, fox2, 500, serie(xfiles, [scifi])).
recurso(netflix, netf2, 50, serie(dark, [thriller, drama])).
recurso(fox, fox3, 127, serie(theMentalist, [drama, misterio])).
recurso(amazon, amz1, 12, serie(goodOmens, [comedia,scifi])).
recurso(netflix, netf1, 810, serie(doctorWho, [scifi, drama])).

% pelicula(título, género, año)
recurso(netflix, netf1, 2, pelicula(veronica, terror, 2017)).
recurso(netflix, netf1, 3, pelicula(infinityWar, accion, 2018)).
recurso(netflix, netf1, 3, pelicula(spidermanFarFromHome, accion, 2019)).

% Y por supuesto también hay información de las descargas de los usuarios.

descarga(mati1009, strangerThings).
descarga(mati1009, infinityWar).
descarga(leoOoOok, dark).
descarga(leoOoOok, powerslave).


% Para esto se pide realizar los siguientes predicados, teniendo en cuenta que todos deben ser totalmente inversibles, a menos que se aclare lo contrario.

% 1) La vida es más fácil cuando hablamos solo de los títulos de las cosas...
% a) titulo/2. Relacionar un recurso con su título.

recurso(Contenido):-
    recurso(_, _, _, Contenido).

titulo(Contenido, Titulo):-
    recurso(Contenido),
    tituloContenido(recurso, Titulo).

tituloContenido(libro(Titulo, _, _), Titulo).
tituloContenido(serie(Titulo, _), Titulo).
tituloContenido(pelicula(Titulo, _, _), Titulo).
tituloContenido(musica(Titulo, _, _), Titulo).


% b) descargaContenido/2. Relaciona a un usuario con un recurso descargado, es decir toda la información completa del mismo.

descargaContenido(Usuario, Contenido):-
    descarga(Usuario, Titulo),
    titulo(Contenido, Titulo).

% 2) contenidoPopular/1. Un contenido es popular si lo descargan más de 10 usuarios.
contenidoPopular(Contenido):-
    recurso(Contenido),
    findall(Usuario, descargaContenido(Usuario, Contenido), Usuarios),
    length(Usuarios, Cantidad),
    Cantidad > 10.

% 3) cinefilo/1  Un usuario es cinéfilo si solo descarga contenido audiovisual (series y películas)
usuario(Usuario):-
    distinct(Usuario, descarga(Usuario, _)). % uso distinct para que no me repita los nombres

cinefilo(Usuario):-
    usuario(Usuario),
    forall(descargaContenido(Usuario, Contenido), esAudiovisual(Contenido)).

esAudiovisual(serie(_, _)).
esAudiovisual(pelicula(_, _, _)).

% 4) totalDescargado/2. Relaciona a un usuario con el total del peso del contenido de sus descargas, en GB
totalDescargado(Usuario, Total):-
    usuario(Usuario),
    findall(Peso, pesoDescarga(Usuario, _, Peso), Pesos),
    sum_list(Pesos, Total).

pesoDescarga(Usuario, Contenido, Peso):-
    descargaContenido(Usuario, Contenido),
    recurso(_, _, Peso, Contenido).

% 5) usuarioCool/1. Un usuario es cool, si solo descarga contenido cool:
% a) La música es cool si el género es kpop o hardRock.
% b) Las series, si tienen más de un género.
% c) Las películas anteriores al 2010 son cool.
% d) Ningún libro es cool.

usuarioCool(Usuario):-
    forall(descargaContenido(Usuario, Contenido), contenidoCool(Contenido)).

contenidoCool(musica(_, kpop, _)).
contenidoCool(musica(_, hardRock, _)).
contenidoCool(series(_, Generos)):-
    length(Generos, Cantidad),
    Cantidad > 1.
contenidoCool(pelicula(_, _, Anio)):-
    Anio < 2010.
% OJO!!! por universo cerrado, no es necesario agregar que el cLibro no es Cool!!!

% 6) empresaHeterogenea/1. Si todo su contenido no es del mismo tipo. Es decir, todo película, o todo serie... etc.
empresaHeterogenea(Empresa):-
    recurso(Empresa, _, _, Contenido1),
    recurso(Empresa, _, _, Contenido2),
    tipoContenido(Contenido1, Tipo1),
    tipoContenido(Contenido2, Tipo2),
    Tipo1 \= Tipo2.

tipoContenido(Contenido, Tipo):- 
    Contenido =.. [Tipo | _].
/* 
podría haber sido: 
tipoContenido(libro(_, _, _), libro).
y así con el resto de los tipos.
*/

% 7) Existe la sobrecarga de equipos, por lo tanto vamos a querer trabajar sobre los servidores a partir del peso de su contenido:
% a) cargaServidor/3. Relaciona a una empresa con un servidor de dicha empresa y su carga, es decir el peso conjunto de todo su contenido.
emprersaServidor(Empresa, Servidor):-
    distinct(Servidor, recurso(Empresa, Servidor, _, _)).

cargaServidor(Empresa, Servidor, Carga):-
    emprersaServidor(Empresa, Servidor),
    findall(Peso, recurso(Empresa, Servidor, Peso, _), Pesos),
    sum_list(Pesos, Carga).

% b) tieneMuchaCarga/2. Relaciona una empresa con su servidor que tiene exceso de carga. Esto pasa cuando supera los 1000 GB de información.
tieneMuchaCarga(Empresa, Servidor):-
    cargaServidor(Empresa, Servidor, Carga),
    Carga > 1000.

% c) servidorMasLiviano/2. Relaciona a la empresa con su servidor más liviano, que es aquel que tiene menor carga, teniendo en cuenta que no puede tener mucha carga.
servidorMasLiviano(Empresa, Servidor):-
    cargaServidor(Empresa, Servidor, Carga1),
    not(tieneMuchaCarga(Empresa, Servidor)),
    not((cargaServidor(Empresa, _, Carga2), Carga2 < Carga1)).

% d) balancearServidor/3. Relaciona una empresa, un servidor que tiene mucha carga y el servidor más liviano de la empresa; de forma tal de planificar una migración de contenido del primero al segundo, los cuales deben ser distintos.
balancearServidor(Empresa, ServidorConMuchaCarga, ServidorMasLiviano):-
    tieneMuchaCarga(Empresa, ServidorConMuchaCarga),
    servidorMasLiviano(Empresa, ServidorMasLiviano).
