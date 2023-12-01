/*
Solución TP de logico
Integrantes:
    - Sahira Kalustian
    - Alexia Deza
    - Leandro Pilar
    - Belén Prada
    */

%1.
%Modelando los carpinchos y sus cualidades como functores.

carpincho(kike,habilidades([saltar, correr]),100, 50, 40). % habilidadess, fuerza, destreza y velocidad
carpincho(nacho,habilidades([olfatear, saltar]), 60, 80, 80).
carpincho(alancito,habilidades([correr]),80, 80, 70).
carpincho(gastoncito,habilidades([olfatear]), 100, 30, 20).
carpincho(sofy,habilidades([saltar, correr, olfatear]), 100, 90, 100).
carpincho(dieguito,habilidades([trepar, correr, saltar]), 99, 99, 80).
carpincho(contu,habilidades([olfatear, lavar, "contabilidad hogarenia", saltar]), 60, 70, 60).

%2.
%Modelando las disciplinas y sus requerimientos como functores.

disciplina(saltoConRamita,habilidades([correr,saltar]),0,0,0).
disciplina(armadoDeMadriguera,habilidades([]),70,0,0).
disciplina(huidaDeDepredador,habilidades([correr, olfatear]),0,0,80).
disciplina(preparacionDeEnsalada,habilidades([olfatear, saltar, "contabilidad hogarenia"]),0,0,0).
disciplina(trepadaDeLigustrina,habilidades([saltar, trepar, correr]),0,0,0).
disciplina(invasionDeCasas,habilidades([]),50,90,0).
disciplina(revolverBasura,habilidades([olfatear, correr]),0,0,50).
disciplina(cebarMate,habilidades([olfatear, "no lavar"]),0,0,0).

%1. bis y 2. bis.
%Relacionando carpinchos con sus habilidades y atributos
%Relacionando disciplinas con sus requerimientos (habilidades necesarias y atributos).

nombreCarpincho(Carpincho):- carpincho(Carpincho, _,_,_,_).
fuerza(Carpincho, Fuerza):- carpincho(Carpincho, _,Fuerza,_,_).
destreza(Carpincho, Destreza):- carpincho(Carpincho, _,_,Destreza,_).
velocidad(Carpincho, Velocidad):- carpincho(Carpincho, _,_,_,Velocidad).
habilidades(Carpincho, Habilidades):- carpincho(Carpincho, habilidades(Habilidades),_,_,_).

nombreDisciplina(Disciplina):- disciplina(Disciplina, _,_,_,_).
fuerza(Disciplina, Fuerza):- disciplina(Disciplina, _,Fuerza,_,_).
destreza(Disciplina, Destreza):- disciplina(Disciplina, _,_,Destreza,_).
velocidad(Disciplina, Velocidad):- disciplina(Disciplina, _,_,_,Velocidad).
habilidades(Disciplina, Habilidades):- disciplina(Disciplina, habilidades(Habilidades),_,_,_).

%3.
%Saber si una disciplina, dada su nombre, es difícil: Esto ocurre cuando se requieren más de 2 habilidades, o bien suma más de 100 puntos de atributos en los requerimientos.

disciplinaDificil(Disciplina):- 
    nombreDisciplina(Disciplina),
    habilidades(Disciplina, Habilidades),
    length(Habilidades, LongitudLista), 2 < LongitudLista.

disciplinaDificil(Disciplina):- 
    nombreDisciplina(Disciplina),
    fuerza(Disciplina, Fuerza), 
    destreza(Disciplina, Destreza),
    velocidad(Disciplina, Velocidad),
    PuntosAtributos is Fuerza + Destreza + Velocidad,
    100 < PuntosAtributos.

%4.
%Implementar un predicado que relacione el nombre de un carpincho y el nombre de una disciplina, si el primero puede realizarla.

%Auxiliar 1
tieneAtributos(Carpincho, Disciplina):-
    nombreCarpincho(Carpincho),
    fuerza(Carpincho,FuerzaC),
    fuerza(Disciplina, FuerzaD),
    destreza(Carpincho,DestrezaC),
    destreza(Disciplina, DestrezaD),
    velocidad(Carpincho,VelocidadC),
    velocidad(Disciplina, VelocidadD),
    FuerzaC >= FuerzaD, DestrezaC >= DestrezaD, VelocidadC >= VelocidadD.

%Auxiliar 2
tieneHabilidadesReq(HabilidadesRequeridas,HabilidadesDisponibles):- 
    member("no lavar",HabilidadesRequeridas),
    not(member(lavar, HabilidadesDisponibles)),
    subtract(HabilidadesRequeridas, ["no lavar"], HabilidadesRequeridasFinal),
    subset(HabilidadesRequeridasFinal,HabilidadesDisponibles).

%Auxiliar 3
tieneHabilidadesReq(HabilidadesRequeridas,HabilidadesDisponibles):- subset(HabilidadesRequeridas,HabilidadesDisponibles).

puedeRealizarla(Carpincho, Disciplina):-
    nombreCarpincho(Carpincho),
    nombreDisciplina(Disciplina),
    habilidades(Carpincho,HabilidadesDisponibles),
    habilidades(Disciplina,HabilidadesRequeridas),
    tieneHabilidadesReq(HabilidadesRequeridas,HabilidadesDisponibles),
    tieneAtributos(Carpincho, Disciplina).

%5. Saber si un carpincho es extraño a partir de su nombre, esto pasa cuando todas las disciplinas que puede realizar son difíciles.

carpinchoEsExtranio(Carpincho):-
    nombreCarpincho(Carpincho),
    disciplinaDificil(Disciplina),
    forall(nombreDisciplina(Disciplina),puedeRealizarla(Carpincho,Disciplina)).

/*6.Saber, dados dos carpinchos y el nombre de una disciplina, cuál es el ganador, sabiendo que:
    ○ Si los dos pueden realizar la disciplina, gana el que tenga más sumatoria de atributos.
    ○ Si uno solo puede realizarla, es el ganador.
    ○ Si ninguno la realiza, ninguno gana.
*/

%Auxiliar 1
sumatoriaAtributos(Carpincho,SumaAtributos):-
    fuerza(Carpincho,Fuerza),
    destreza(Carpincho,Destreza),
    velocidad(Carpincho,Velocidad),
    SumaAtributos is Fuerza + Destreza + Velocidad.

%Auxiliar 2
/* Respecto a línea "SumaAtributos1 \= SumaAtributos2,": 
    No se indica en el enunciado qué sucede en caso de empate entre dos competidores con igual suma de atributos. Por ende, en caso de que esto suceda la respuesta a la consulta con predicado competencia.... será "False". Cabe aclarar que con el listado de carpinchos actuales existe un único caso en que dos de ellos poseen igual suma de atributos (kike y contu). No obstante, no comparten disciplinas realizables por lo que con el listado de carpinchos actuales no será una respuesta posible.*/
carpinchoConMejoresAtributos(Carpincho1, Carpincho2, MejorCarpincho):-
    sumatoriaAtributos(Carpincho1,SumaAtributos1),
    sumatoriaAtributos(Carpincho2,SumaAtributos2),
    SumaAtributos1 \= SumaAtributos2,
    max_member(MayorSuma, [SumaAtributos1,SumaAtributos2]),
    nth1(NroGanador,[SumaAtributos1,SumaAtributos2], MayorSuma),
    nth1(NroGanador, [Carpincho1, Carpincho2], MejorCarpincho).

competencia(Carpincho1,Carpincho2,Disciplina, Ganador):-
    nombreDisciplina(Disciplina),
    nombreCarpincho(Carpincho1),
    nombreCarpincho(Carpincho2),
    Carpincho1 \= Carpincho2,
    findall(Competidor,(puedeRealizarla(Competidor, Disciplina), member(Competidor,[Carpincho1, Carpincho2])),PuedenRealizarla),
    definicionGanador(PuedenRealizarla, Ganador).

definicionGanador(PuedenRealizarla, Ganador):-
    length(PuedenRealizarla,Largo), Largo is 1,
    member(Ganador, PuedenRealizarla).

definicionGanador(PuedenRealizarla, Ganador):-
    length(PuedenRealizarla,Largo), Largo is 2,
    nth1(1,PuedenRealizarla,Carpincho1), 
    nth1(2,PuedenRealizarla,Carpincho2),
    carpinchoConMejoresAtributos(Carpincho1, Carpincho2, Ganador).

/*7. Durante la cuarentena, nuestros amiguitos estuvieron preparándose para este gran evento deportivo con distintos entrenamientos. Implementar los siguientes entrenamientos, que relacionan una cantidad, un carpincho (completo) a entrenar y el mismo carpincho después de entrenar:

    ○ pesasCarpinchas/3: aumenta la fuerza de un carpincho un cuarto de la cantidad de peso que levantaron.
    ○ atrapaLaRana/3: aumenta la destreza en igual cantidad que las ranas atrapadas.
    ○ cardiopincho/3: aumenta la velocidad el doble de los kilómetros recorridos (claramente,recorridos en cinta, porque no podían salir a entrenar).
    ○ carssfit/3: aumenta la destreza y la fuerza en la cantidad de minutos que se entrena, pero también baja la velocidad el doble de esa cantidad.*/

%Nota: No hace falta que estos 4 predicados sean inversibles para ninguno de sus argumentos

% Aux 1
carpinchoQueEntrena(Carpincho, carpincho(Carpincho,Habilidades,Fuerza,Destreza,Velocidad)):-
    habilidades(Carpincho,Habilidades),
    fuerza(Carpincho, Fuerza),
    destreza(Carpincho, Destreza),
    velocidad(Carpincho, Velocidad).

% Aux 2
modificaFuerza(Carpincho, DeltaFuerza, FuerzaResultante):-
    fuerza(Carpincho,Fuerza),
    FuerzaResultante is Fuerza + DeltaFuerza.

% Aux 3
modificaDestreza(Carpincho, DeltaDestreza, DestrezaResultante):-
    destreza(Carpincho, Destreza),
    DestrezaResultante is Destreza + DeltaDestreza.

% Aux 4
modificaVelocidad(Carpincho, DeltaVelocidad, VelocidadResultante):-
    velocidad(Carpincho, Velocidad),
    VelocidadResultante is Velocidad + DeltaVelocidad.

pesasCarpinchas(Carpincho, Peso, CarpinchoEntrenado):-
    carpinchoQueEntrena(Carpincho, carpincho(Carpincho,Habilidades,_,Destreza,Velocidad)),
    DeltaFuerza is (1/4)*Peso,
    modificaFuerza(Carpincho, DeltaFuerza, FuerzaResultante),
    CarpinchoEntrenado = carpincho(Carpincho,Habilidades,FuerzaResultante,Destreza,Velocidad).

atrapaLaRana(Carpincho, RanasAtrapadas, CarpinchoEntrenado):-
    carpinchoQueEntrena(Carpincho, carpincho(Carpincho,Habilidades,Fuerza,_,Velocidad)),
    DeltaDestreza is RanasAtrapadas,
    modificaDestreza(Carpincho, DeltaDestreza, DestrezaResultante),
    CarpinchoEntrenado = carpincho(Carpincho,Habilidades,Fuerza,DestrezaResultante,Velocidad).

cardioPincho(Carpincho, KmRecorridos, CarpinchoEntrenado):-
    carpinchoQueEntrena(Carpincho, carpincho(Carpincho,Habilidades,Fuerza,Destreza,_)),
    DeltaVelocidad is 2*KmRecorridos,
    modificaVelocidad(Carpincho, DeltaVelocidad, VelocidadResultante),
    CarpinchoEntrenado = carpincho(Carpincho,Habilidades,Fuerza,Destreza,VelocidadResultante).

carssfit(Carpincho, MinutosEntrenamiento, CarpinchoEntrenado):-
    carpinchoQueEntrena(Carpincho, carpincho(Carpincho,Habilidades,_,_,_)),
    DeltaFuerza is MinutosEntrenamiento,
    DeltaDestreza is MinutosEntrenamiento,
    DeltaVelocidad is (-2)*MinutosEntrenamiento,
    modificaFuerza(Carpincho, DeltaFuerza, FuerzaResultante),
    modificaDestreza(Carpincho, DeltaDestreza, DestrezaResultante),
    modificaVelocidad(Carpincho, DeltaVelocidad, VelocidadResultante),
    CarpinchoEntrenado = carpincho(Carpincho,Habilidades,FuerzaResultante,DestrezaResultante,VelocidadResultante).

%8. Hacer aCuantosLesGana/3. Que relaciona el nombre de un carpincho, nombre de disciplina y la cantidad de carpinchos a los que les gana en esa disciplina

aCuantosLesGana(CarpinchoGanador, Disciplina, NroDerrotados):-
    nombreCarpincho(CarpinchoGanador),
    nombreDisciplina(Disciplina),
    findall(Carpincho,(competencia(CarpinchoGanador,Carpincho,Disciplina,CarpinchoGanador),Carpincho \= CarpinchoGanador),Derrotados),
    length(Derrotados,NroDerrotados).

%9. Hacer laRompeEn/2, que relaciona el nombre de un carpincho y una disciplina, si dicho carpincho gana siempre en dicha disciplina.

laRompeEn(CarpinchoQueLaRompe, Disciplina):-
    nombreCarpincho(CarpinchoQueLaRompe),
    nombreDisciplina(Disciplina),
    aCuantosLesGana(CarpinchoQueLaRompe, Disciplina, NroDerrotados),
    findall(Carpincho, nombreCarpincho(Carpincho), TodaLaComunidadDeCarpinchos),
    length(TodaLaComunidadDeCarpinchos, NroCarpinchos),
    NroDerrotados is NroCarpinchos - 1.

/*10. A partir de una lista de nombres de disciplinas, poder generar un Drintim (un equipo) de carpinchos donde cada uno de los integrantes sea el ganador indiscutido en cada disciplina, es decir, el que más gana.
Nota: No hace falta que este predicado sea inversible para las disciplinas, sí para el equipo */

laRompeEn(Carpincho, [Disciplina|_]):-
    laRompeEn(Carpincho,Disciplina).

laRompeEn(Carpincho, [_|Disciplinas]):-
    laRompeEn(Carpincho,Disciplinas).

drintim(GanadoresIndiscutidos, ListaDisciplinas):-
    findall(Carpincho, laRompeEn(Carpincho, ListaDisciplinas), ListaGanadoresConRepeticion),
    list_to_set(ListaGanadoresConRepeticion, GanadoresIndiscutidos).