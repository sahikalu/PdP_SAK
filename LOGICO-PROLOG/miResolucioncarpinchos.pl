/*
Solución TP de logico
Integrantes:
- Sahira Kalustian
- Alexia Deza
- Leandro Pilar
- Belén Prada
*/

/*
Rememorando el primer año de pandemia junto a la recordada cuareterna, recordamos que estuvo todo bastante desbalanceado, ya que hubo mucho de unas cosas y muy poco de otras. Nos proponemos juntar dos de esos extremos para balancear nuestros recuerdos de aquella época: Carpinchos (que hubo mucho) y JJOO (que hubo muy poco, se pasaron al año siguiente).

En esta oportunidad, vamos a modelar los Juegos Carpincholímpicos, en los cuales nuestros distinguidos atletas deben realizar distintas disciplinas.

De cada carpincho sabemos su nombre, una lista de habilidades (individuos) y sus atributos de fuerza, destreza y velocidad (que son números, siempre referidos en ese orden).

Tenemos algunos carpinchos de ejemplo:

- Kike: que sabe saltar y correr, y sus atributos son 100, 50, 40
- Nacho: sabe olfatear y saltar, y sus atributos son 60, 80, 80
- Alancito: sabe correr y sus atributos son 80, 80, 70
- Gastoncito: sabe olfatear y sus atributos son 100, 30, 20.
- Sofy: sabe saltar, correr, olfatear y sus atributos son 100, 90, 100.
- Dieguito: sabe trepar, correr y saltar, y sus atributos son 99, 99, 80.
- Contu: sabe olfatear, lavar, contabilidad hogareña, saltar, y sus atributos son 60, 70, 60.

Las disciplinas tienen distintos tipos de restricciones:
- De habilidades: Define una lista de habilidades que tiene que tener el carpincho para poder participar.
- De atributos: Tiene valores de los atributos que tiene que cumplir el carpincho (donde el valor puede ser 0 si no es necesario)
- Mixtas: Combinación de las dos anteriores.

Además todas tienen su nombre. Algunas de las disciplinas son:
1) Salto con Ramita: que tiene restricción de habilidades: correr y saltar
2) Armado de Madriguera: requiere 70 de fuerza
3) Huida de Depredador: requiere saber correr, olfatear y una velocidad de por lo menos 80
4) Preparación de Ensalada: requiere olfatear, saltar y contabilidad hogareña
5) Trepada de Ligustrina: requiere saltar, trepar y correr
6) Invasión de casas: requiere 90 de destreza y 50 de fuerza
7) Revolver basura: requiere olfatear, correr y una velocidad de 50
8) Cebar mate: requiere olfatear y no lavar.

Resolver haciendo que todos los predicados sean inversibles, salvo que se indique lo contrario.
Aclaración: No es necesario que los predicados auxiliares sean inversibles.
*/

listaDentroDeLista([], _).
listaDentroDeLista([X|Xs], [X|Ys]) :- esta_dentro(Xs, Ys).
listaDentroDeLista([X|Xs], [_|Ys]) :- esta_dentro([X|Xs], Ys).

% 1) Modelar con functores a cada uno de los carpinchos y definir un predicado para indicar la existencia y poder usar de generador.
% habilidades([habilidades], fuerza, destreza y velocidad).
% carpincho(nombreCarpincho,habiliddes([habilidadess], fuerza, destreza y velocidad)).
carpincho(kike, habilidades([saltar, correr], 100, 50, 40)).
carpincho(nacho, habilidades([olfatear, saltar], 60, 80, 80)).
carpincho(alancito, habilidades([correr], 80, 80, 70)).
carpincho(gastoncito, habilidades([olfatear], 100, 30, 20)).
carpincho(sofy, habilidades([saltar, corre4r, olfatear], 100, 90, 100)).
carpincho(dieguito, habilidades([tre4par, correr, saltar], 99, 99, 80)).
carpincho(contu, habilidades([olfatear, lavar, contabilidadHogarenia, saltar], 60, 70, 60)).

nombreCarpincho(Carpincho):- carpincho(Carpincho, habilidades(_, _, _, _)).
habilidadesCarpincho(Carpincho, Habilidades):- carpincho(Carpincho, habilidades(Habilidades, _, _, _)).
fuerzaCarpincho(Carpincho, Fuerza):- carpincho(Carpincho, habilidades(_, Fuerza_, _, _)).
destrezaCarpincho(Carpincho, Destreza):- carpincho(Carpincho, habilidades(_, _, Destreza, _)).
velocidadCarpincho(Carpincho, Velocidad):- carpincho(Carpincho, habilidades(_, _, _, Velocidad)).

% 2) Modelar las disciplinas en relación a sus restricciones.
disciplina(Disciplina, restriccionDeHabilidades(HabilidadesQueRestringen)):-
    listaDentroDeLista(Habilidades, habilidades(Habilidades, _, _, _)) == true,
    Habilidades = HabilidadesQueRestringen,
    disciplina(Disciplina, habilidades(Habilidades, _, _, _)).

disciplina(Disciplina, restriccionDeAtributos(Fuerza, Destreza, Velocidad)):-
    disciplina(Disciplina, habilidades(_, Fuerza, Destreza, Velocidad)).
disciplina(Disciplina, restriccionMixta(Habilidades, Fuerza, Destreza, Velocidad)):-
    disciplina(Disciplina, habilidades(Habilidades, Fuerza, Destreza, Velocidad)).

disciplina(saltoConRamita, habilidades(Habilidades, _, _, _)):-
    Habilidades = [saltar, correr].
disciplina(armadoDeMadriguera, habilidades(_, 70, 0, 0)).
disciplina(huidaDeDepredador, mixta([correr, olfatear], habilidades(_, 0, 0, Velocidad))):-
    Velocidad >= 80.
disciplina(preparacionDeEnsalada, habilidades([olfatear, saltar, contabilidadHogarenia], _, _, _)).
disciplina(trepadaDeLigustrina, habilidades([saltar, trepar, correr], 0, 0, 0)).
disciplina(invasionDeCasas, habilidades(_, 0, 90, 50)).
disciplina(revolverBasura, habilidades([olfatear, correr], 0, 0, 50)).
disciplina(cebarMate, habilidades([olfatear, noLavar], _, _, _)).

% 3) Saber si una disciplina, dada su nombre, es difícil: Esto ocurre cuando se requieren más de 2 habilidades, o bien suma más de 100 puntos de atributos en los requerimientos.
% - Casos de pruebas
% i) Trepada de Ligustrina es una disciplina difícil
% ii) Invasión de casas es una disciplina difícil
% iii) Armado de Madriguera no es difícil

% 4) Implementar un predicado que relacione el nombre de un carpincho y el nombre de una disciplina, si el primero puede realizarla.
% - Casos de pruebas
% i) Dieguito puede trepar ligustrina
% ii) Kike no  puede revolver basura
% iii) Sofy puede invadir casas

% 5) Saber si un carpincho es extraño a partir de su nombre, esto pasa cuando todas las disciplinas que puede realizar son difíciles.
% - Casos de pruebas
% i) Contu es extraña
% ii) Nacho no es extraño

% 6) Saber, dados dos carpinchos y el nombre de una disciplina, cuál es el ganador, sabiendo que: 
% - Si los dos pueden realizar la disciplina, gana el que tenga más sumatoria de atributos.
% - Si uno solo puede realizarla, es el ganador.
% - Si ninguno la realiza, ninguno gana.
% Nota: Pensar... ¿Cuántas cosas se deben relacionar?
% - Casos de pruebas
% i) Nacho le gana a Alancito en cebar mate.
% ii) Sofy le gana a Contu en salto con ramita.

% 7) Durante la cuarentena, nuestros amiguitos estuvieron preparándose para este gran evento deportivo con distintos entrenamientos. Implementar los siguientes entrenamientos, que relacionan una cantidad, un carpincho (completo) a entrenar y el mismo carpincho después de entrenar:
% - pesasCarpinchas/3: aumenta la fuerza de un carpincho un cuarto de la cantidad de peso que levantaron.
% - atrapaLaRana/3: aumenta la destreza en igual cantidad que las ranas atrapadas.
% - cardiopincho/3: aumenta la velocidad el doble de los kilómetros recorridos (claramente, recorridos en cinta, porque no podían salir a entrenar).
% - carssfit/3: aumenta la destreza y la fuerza en la cantidad de minutos que se entrena, pero también baja la velocidad el doble de esa cantidad.
% Nota: No hace falta que estos 4 predicados sean inversibles para ninguno de sus argumentos.
% - Casos de pruebas
% i) Desarrollar un caso de prueba para cada uno de los 4 predicados

% 8) Hacer aCuantosLesGana/3. Que relaciona el nombre de un carpincho, nombre de disciplina y la cantidad de carpinchos a los que les gana en esa disciplina.
% - Casos de pruebas
% i) Nacho le gana a 5 en cebar mate
% ii) Kike le gana a 4 en salto con ramita
% iii) Sofy le gana a 6 en revolver basura

% 9) Hacer laRompeEn/2, que relaciona el nombre de un carpincho y una disciplina, si dicho carpincho gana siempre en dicha disciplina.
% - Casos de pruebas
% i) Sofy la rompe en revolver basura y en huida de depredador
% ii) Contu la rompe en preparación de ensalada 

% 10) A partir de una lista de nombres de disciplinas, poder generar un Drintim (un equipo) de carpinchos donde cada uno de los integrantes sea el ganador indiscutido en cada disciplina, es decir, el que más gana.
% Nota: No hace falta que este predicado sea inversible para las disciplinas, sí para el equipo.
% - Casos de pruebas
% i) Un drintim para revolver basura y preparación de ensalada está formado por Sofy y Contu.
% ii) Un drintim para revolver basura y huida de depredador está formado únicamente por Sofy.