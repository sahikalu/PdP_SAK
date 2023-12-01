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

Kike: que sabe saltar y correr, y sus atributos son 100, 50, 40
Nacho: sabe olfatear y saltar, y sus atributos son 60, 80, 80
Alancito: sabe correr y sus atributos son 80, 80, 70
Gastoncito: sabe olfatear y sus atributos son 100, 30, 20.
Sofy: sabe saltar, correr, olfatear y sus atributos son 100, 90, 100.
Dieguito: sabe trepar, correr y saltar, y sus atributos son 99, 99, 80.
Contu: sabe olfatear, lavar, contabilidad hogareña, saltar, y sus atributos son 60, 70, 60.

Las disciplinas tienen distintos tipos de restricciones:
De habilidades: Define una lista de habilidades que tiene que tener el carpincho para poder participar.
De atributos: Tiene valores de los atributos que tiene que cumplir el carpincho (donde el valor puede ser 0 si no es necesario)
Mixtas: Combinación de las dos anteriores.

Además todas tienen su nombre. Algunas de las disciplinas son:
Salto con Ramita: que tiene restricción de habilidades: correr y saltar
Armado de Madriguera: requiere 70 de fuerza
Huida de Depredador: requiere saber correr, olfatear y una velocidad de por lo menos 80
Preparación de Ensalada: requiere olfatear, saltar y contabilidad hogareña
Trepada de Ligustrina: requiere saltar, trepar y correr
Invasión de casas: requiere 90 de destreza y 50 de fuerza
Revolver basura: requiere olfatear, correr y una velocidad de 50
Cebar mate: requiere olfatear y no lavar.

Resolver haciendo que todos los predicados sean inversibles, salvo que se indique lo contrario.
Aclaración: No es necesario que los predicados auxiliares sean inversibles.
*/

/* 1) Modelar con functores a cada uno de los carpinchos y definir un predicado para indicar la existencia y poder usar de generador.*/

/*Un carpincho como un functor: habilidades, fuerza, destreza y velocidad*/
carpincho(carpincho(kike,[saltar, correr],100, 50, 40)).  
carpincho(carpincho(nacho,[olfatear, saltar], 60, 80, 80)).
carpincho(carpincho(alancito,[correr],80, 80, 70)).
carpincho(carpincho(gastoncito,[olfatear], 100, 30, 20)).
carpincho(carpincho(sofy,[saltar, correr, olfatear], 100, 90, 100)).
carpincho(carpincho(dieguito,[trepar, correr, saltar], 99, 99, 80)).
carpincho(carpincho(contu,[olfatear, lavar, contabilidadHogarenia, saltar], 60, 70, 60)).

%/*Identificando al carpincho por su nombre (generador):
nombreCarpincho(Nombre, carpincho(Nombre, Habilidades, Fuerza, Destreza, Velocidad)):- 
    carpincho(carpincho(Nombre, Habilidades, Fuerza, Destreza, Velocidad)).

/* a la disciplina por su nombre:*/
nombreDisciplina(Disciplina):- disciplina(Disciplina, _,_,_,_).

/*Identificando atributos de un carpincho e identificando requerimientos de atributos de una disciplina.*/
fuerza(carpincho(_, _, Fuerza, _, _), Fuerza).
fuerzaRequerida(Disciplina, Fuerza):- disciplina(Disciplina, _, Fuerza, _, _).
destreza(carpincho(_, _, _ , Destreza, _), Destreza).
destrezaRequerida(Disciplina, Destreza):- disciplina(Disciplina, _, _ ,Destreza, _).
velocidad(carpincho(_, _, _, _, Velocidad), Velocidad).
velocidadRequerida(Disciplina, Velocidad):- disciplina(Disciplina, _, _, _, Velocidad).

/*Identificando habilidades de un carpincho -- Identificando habilidades requeridas por una disciplina.*/
habilidades(carpincho(_, Habilidades, _, _, _), Habilidades).
habilidadesRequeridas(Disciplina, Habilidades):- disciplina(Disciplina, Habilidades, _, _, _).

/*2) Modelar las disciplinas en relación a sus restricciones.*/

disciplina(saltoConRamita, [correr,saltar], 0, 0, 0).
disciplina(armadoDeMadriguera, [], 70, 0, 0).
disciplina(huidaDeDepredador, [correr, olfatear], 0, 0, 80).
disciplina(preparacionDeEnsalada, [olfatear, saltar, contabilidadHogarenia], 0, 0, 0).
disciplina(trepadaDeLigustrina, [saltar, trepar, correr], 0, 0, 0).
disciplina(invasionDeCasas, [], 50, 90, 0).
disciplina(revolverBasura, [olfatear, correr], 0, 0, 50).
disciplina(cebarMate, [olfatear, "no lavar"], 0, 0, 0).

/*
3) Saber si una disciplina, dada su nombre, es difícil: Esto ocurre cuando se requieren más de 2 habilidades, o bien suma más de 100 puntos de atributos en los requerimientos.
    - Casos de pruebas:
        i.Trepada de Ligustrina es una disciplina difícil.
        ii.Invasión de casas es una disciplina difícil.
        iii.Armado de Madriguera no es difícil.
*/

disciplinaDificil(Disciplina):- 
    habilidadesRequeridas(Disciplina, Habilidades),
    length(Habilidades, LongitudLista), 
    2 < LongitudLista.

disciplinaDificil(Disciplina):- 
    fuerzaRequerida(Disciplina, Fuerza), 
    destrezaRequerida(Disciplina, Destreza),
    velocidadRequerida(Disciplina, Velocidad),
    PuntosAtributos is Fuerza + Destreza + Velocidad,
    100 < PuntosAtributos.

/*
4) Implementar un predicado que relacione el nombre de un carpincho y el nombre de una disciplina, si el primero puede realizarla.
    - Casos de pruebas:
        i.Dieguito puede trepar ligustrina
        ii.Kike no  puede revolver basura
        iii.Sofy puede invadir casas
*/

/*Aux 1*/
tieneAtributos(FuerzaC, DestrezaC, VelocidadC, Disciplina):-
    fuerzaRequerida(Disciplina, FuerzaD), 
    destrezaRequerida(Disciplina, DestrezaD), 
    velocidadRequerida(Disciplina, VelocidadD),
    FuerzaC >= FuerzaD, DestrezaC >= DestrezaD, VelocidadC >= VelocidadD.

/*Aux 2 (se asume que si un carpincho no posee la habilidad de lavar, entonces es su habilidad "no lavar")*/
tieneHabilidades(HabilidadesRequeridas, HabilidadesDisponibles):- 
    member("no lavar", HabilidadesRequeridas),
    not(member(lavar, HabilidadesDisponibles)),
    subtract(HabilidadesRequeridas, ["no lavar"], HabilidadesRequeridasFinal),
    subset(HabilidadesRequeridasFinal, HabilidadesDisponibles).

/*Aux 3*/
tieneHabilidades(HabilidadesRequeridas, HabilidadesDisponibles):- 
    subset(HabilidadesRequeridas, HabilidadesDisponibles).

puedeRealizarla(Carpincho, Disciplina):-
    nombreDisciplina(Disciplina),
    nombreCarpincho(Carpincho, CualidadesCarpincho),
    fuerza(CualidadesCarpincho,FuerzaC), 
    destreza(CualidadesCarpincho,DestrezaC), 
    velocidad(CualidadesCarpincho,VelocidadC),
    habilidades(CualidadesCarpincho, HabilidadesDisponibles),
    habilidadesRequeridas(Disciplina, HabilidadesRequeridas),
    tieneHabilidades(HabilidadesRequeridas, HabilidadesDisponibles),
    tieneAtributos(FuerzaC, DestrezaC, VelocidadC, Disciplina).

/*
5) Saber si un carpincho es extraño a partir de su nombre, esto pasa cuando todas las disciplinas que puede realizar son difíciles.
    - Casos de pruebas:
        i.Contu es extraña
        ii.Nacho no es extraño
*/

carpinchoEsExtranio(Carpincho):-
    nombreCarpincho(Carpincho,_),
    forall(puedeRealizarla(Carpincho,Disciplina), disciplinaDificil(Disciplina)).

/*
6) Saber, dados dos carpinchos y el nombre de una disciplina, cuál es el ganador, sabiendo que: 
    - Si los dos pueden realizar la disciplina, gana el que tenga más sumatoria de atributos.
    - Si uno solo puede realizarla, es el ganador.
    - Si ninguno la realiza, ninguno gana.

Nota: Pensar... ¿Cuántas cosas se deben relacionar?

    - Casos de pruebas:
        i.Nacho le gana a Alancito en cebar mate.
        ii.Sofy le gana a Contu en salto con ramita.
*/

/* Aux 1*/
sumatoriaAtributos(Carpincho, SumaAtributos):-
    nombreCarpincho(Carpincho, CualidadesCarpincho),
    fuerza(CualidadesCarpincho, Fuerza),
    destreza(CualidadesCarpincho, Destreza),
    velocidad(CualidadesCarpincho, Velocidad),
    SumaAtributos is Fuerza + Destreza + Velocidad.

/*Aux 2*/
/* Respecto a línea "SumaAtributos1 \= SumaAtributos2,": 
    No se indica en el enunciado qué sucede en caso de empate entre dos competidores con igual suma de atributos. Por ende, en caso de que esto suceda la respuesta a la consulta con predicado competencia.... será "False". Cabe aclarar que con el listado de carpinchos actuales existe un único caso en que dos de ellos poseen igual suma de atributos (kike y contu). No obstante, no comparten disciplinas realizables por lo que con el listado de carpinchos actuales no será una respuesta posible.
*/
carpinchoConMejoresAtributos(Carpincho1, Carpincho2, MejorCarpincho):-
    sumatoriaAtributos(Carpincho1, SumaAtributos1),
    sumatoriaAtributos(Carpincho2, SumaAtributos2),
    SumaAtributos1 \= SumaAtributos2,
    max_member(MayorSuma, [SumaAtributos1, SumaAtributos2]),
    nth1(NroGanador,[SumaAtributos1 ,SumaAtributos2], MayorSuma),
    nth1(NroGanador, [Carpincho1, Carpincho2], MejorCarpincho).

competencia(Carpincho1, Carpincho2, Disciplina, Ganador):-
    nombreDisciplina(Disciplina),
    nombreCarpincho(Carpincho1,_),
    nombreCarpincho(Carpincho2,_),
    Carpincho1 \= Carpincho2,
    findall(Competidor, (puedeRealizarla(Competidor, Disciplina), member(Competidor, [Carpincho1, Carpincho2])), PuedenRealizarla),
    definicionGanador(PuedenRealizarla, Ganador).

definicionGanador(PuedenRealizarla, Ganador):-
    length(PuedenRealizarla, Largo), Largo = 1,
    member(Ganador, PuedenRealizarla).

/*
definicionGanador(PuedenRealizarla, Ganador):-
    length(PuedenRealizarla, Largo), Largo = 2,
    nth1(1, PuedenRealizarla, Carpincho1), 
    nth1(2, PuedenRealizarla, Carpincho2),
    carpinchoConMejoresAtributos(Carpincho1, Carpincho2, Ganador). 
*/
    
/* correcion issue 5 usando pattern matching */

definicionGanador([Carpincho1, Carpincho2], Ganador) :-
    carpinchoConMejoresAtributos(Carpincho1, Carpincho2, Ganador).


/*
7) Durante la cuarentena, nuestros amiguitos estuvieron preparándose para este gran evento deportivo con distintos entrenamientos. Implementar los siguientes entrenamientos, que relacionan una cantidad, un carpincho (completo) a entrenar y el mismo carpincho después de entrenar:

Nota: No hace falta que estos 4 predicados sean inversibles para ninguno de sus argumentos.
    - Casos de pruebas:
        i.Desarrollar un caso de prueba para cada uno de los 4 predicados. 
*/

%Aux 1
carpinchoAEntrenar(CarpinchoAEntrenar, Habilidades, Fuerza, Destreza, Velocidad):-
    habilidades(CarpinchoAEntrenar, Habilidades),
    fuerza(CarpinchoAEntrenar, Fuerza),
    destreza(CarpinchoAEntrenar, Destreza),
    velocidad(CarpinchoAEntrenar, Velocidad).

%Aux 2
modificaFuerza(Fuerza, DeltaFuerza, FuerzaResultante):-
    FuerzaResultante is Fuerza + DeltaFuerza.

%Aux 3
modificaDestreza(Destreza, DeltaDestreza, DestrezaResultante):-
    DestrezaResultante is Destreza + DeltaDestreza.

%Aux 4
modificaVelocidad(Velocidad, DeltaVelocidad, VelocidadResultante):-
    VelocidadResultante is Velocidad + DeltaVelocidad.

%pesasCarpinchas/3: aumenta la fuerza de un carpincho un cuarto de la cantidad de peso que levantaron.
pesasCarpinchas(Peso, CarpinchoAEntrenar, carpincho(Carpincho, Habilidades, FuerzaResultante, Destreza, Velocidad)):-
    nombreCarpincho(Carpincho, CarpinchoAEntrenar),
    carpinchoAEntrenar(CarpinchoAEntrenar, Habilidades, Fuerza, Destreza, Velocidad),
    DeltaFuerza is (1 / 4) * Peso,
    modificaFuerza(Fuerza, DeltaFuerza, FuerzaResultante).

%atrapaLaRana/3: aumenta la destreza en igual cantidad que las ranas atrapadas.
atrapaLaRana(RanasAtrapadas, CarpinchoAEntrenar, carpincho(Carpincho, Habilidades, Fuerza, DestrezaResultante, Velocidad)):-
    nombreCarpincho(Carpincho, CarpinchoAEntrenar),
    carpinchoAEntrenar(CarpinchoAEntrenar, Habilidades, Fuerza, Destreza, Velocidad),
    DeltaDestreza = RanasAtrapadas,
    modificaDestreza(Destreza, DeltaDestreza, DestrezaResultante).

%cardiopincho/3: aumenta la velocidad el doble de los kilómetros recorridos (claramente, recorridos en cinta, porque no podían salir a entrenar).
cardioPincho(Carpincho, KmRecorridos, carpincho(Carpincho,Habilidades,Fuerza,Destreza,VelocidadResultante)):-
    nombreCarpincho(Carpincho, CarpinchoAEntrenar),
    carpinchoAEntrenar(CarpinchoAEntrenar, Habilidades, Fuerza, Destreza, Velocidad),
    DeltaVelocidad is 2 * KmRecorridos,
    modificaVelocidad(Velocidad, DeltaVelocidad, VelocidadResultante).

/*carssfit/3: aumenta la destreza y la fuerza en la cantidad de minutos que se entrena, pero también baja la velocidad el doble de esa cantidad.*/
carssFit(Carpincho, MinutosEntrenamiento, carpincho(Carpincho, Habilidades, FuerzaResultante, DestrezaResultante, VelocidadResultante)):-
    nombreCarpincho(Carpincho, CarpinchoAEntrenar),
    carpinchoAEntrenar(CarpinchoAEntrenar, Habilidades, Fuerza, Destreza, Velocidad),
    DeltaFuerza = MinutosEntrenamiento,
    DeltaDestreza is MinutosEntrenamiento,
    DeltaVelocidad is (-2) * MinutosEntrenamiento,
    modificaFuerza(Fuerza, DeltaFuerza, FuerzaResultante),
    modificaDestreza(Destreza, DeltaDestreza, DestrezaResultante),
    modificaVelocidad(Velocidad, DeltaVelocidad, VelocidadResultante).

/*
8) Hacer aCuantosLesGana/3. Que relaciona el nombre de un carpincho, nombre de disciplina y la cantidad de carpinchos a los que les gana en esa disciplina.
    - Casos de pruebas:
        i. Nacho le gana a 5 en cebar mate
        ii. Kike le gana a 4 en salto con ramita
        iii. Sofy le gana a 6 en revolver basura
*/

aCuantosLesGana(CarpinchoGanador, Disciplina, NroDerrotados):-
    nombreCarpincho(CarpinchoGanador,_),
    nombreDisciplina(Disciplina),
    findall(Carpincho, competencia(CarpinchoGanador, Carpincho, Disciplina, CarpinchoGanador), Derrotados),
    length(Derrotados, NroDerrotados).

/*
9) Hacer laRompeEn/2, que relaciona el nombre de un carpincho y una disciplina, si dicho carpincho gana siempre en dicha disciplina.
    - Casos de pruebas:
    i. Sofy la rompe en revolver basura y en huida de depredador
    ii. Contu la rompe en preparación de ensalada. 
*/

laRompeEn(CarpinchoQueLaRompe, Disciplina):- 
    nombreDisciplina(Disciplina), 
    nombreCarpincho(CarpinchoQueLaRompe,_),
    forall((aCuantosLesGana(CarpinchoQueLaRompe,Disciplina,NroVictoriasDelCampeon),aCuantosLesGana(OtroCarpincho,Disciplina,NroVictorias), OtroCarpincho \= CarpinchoQueLaRompe), NroVictoriasDelCampeon > NroVictorias).
/*
10) A partir de una lista de nombres de disciplinas, poder generar un Drintim (un equipo) de carpinchos donde cada uno de los integrantes sea el ganador indiscutido en cada disciplina, es decir, el que más gana.
Nota: No hace falta que este predicado sea inversible para las disciplinas, sí para el equipo.
    - Casos de pruebas:
        i.Un drintim para revolver basura y preparación de ensalada está formado por Sofy y Contu.
        ii.Un drintim para revolver basura y huida de depredador está formado únicamente por Sofy.*/

%Solución con maplist
drintim(GanadoresIndiscutidos, ListaDisciplinas):-
    maplist(laRompeEn, Carpinchos, ListaDisciplinas), 
    list_to_set(Carpinchos, GanadoresIndiscutidos).

/*
Solo para referencias:

Solución punto 10 con Recursividad

laRompeDrintim(Carpincho, [Disciplina|_]):-
    laRompeEn(Carpincho,Disciplina).

laRompeDrintim(Carpincho, [_|Disciplinas]):-
    laRompeDrintim(Carpincho,Disciplinas).

drintim(GanadoresIndiscutidos, ListaDisciplinas):-
    findall(Carpincho, laRompeDrintim(Carpincho, ListaDisciplinas), ListaGanadoresConRepeticion),
    list_to_set(ListaGanadoresConRepeticion, GanadoresIndiscutidos).
*/