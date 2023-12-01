:- include(TPLogico).

:- begin_tests(punto3).

test("i.Trepada de Ligustrina es una disciplina difícil."):-
    disciplinaDificil(trepadaDeLigustrina).

test("ii.Invasión de casas es una disciplina difícil."):-
    disciplinaDificil(invasionDeCasas).

test("iii.Armado de Madriguera no es difícil.", fail):-
    disciplinaDificil(armadoDeMadriguera).

:- end_tests(punto3).

:- begin_tests(punto5).

test("i. Contu es extraña"):-
    carpinchoEsExtranio(contu).

test("ii. Nacho no es extraño", fail):-
    carpinchoEsExtranio(nacho).

:- end_tests(punto5).

:- begin_tests(punto6).

test("i. Nacho le gana a Alancito en cebar mate."):-
    competencia(nacho,alancito,cebarMate, nacho), !. 
/*Utilizo el operador de corte (!) al final de la consulta, para evitar que Prolog busque más soluciones después de encontrar la primera*/

test("ii. Sofy le gana a Contu en salto con ramita."):-
    competencia(sofy,contu,saltoConRamita, sofy), !. 
/* Utilizo el operador de corte (!) al final de la consulta, para evitar que Prolog busque más soluciones después de encontrar la primera*/

:- end_tests(punto6).

:- begin_tests(punto7_Atributos).

test("i. Nacho levanta 100 kg en pesasCarpinchas y su fuerza aumenta en 25 (ya tenía 60, entonces queda en 85)"):-
    fuerza(CarpinchoEntrenado, 85):-
        pesasCarpinchas(nacho, 100, CarpinchoEntrenado).

test("ii. Sofy atrapa 10 ranas en atrapaLaRana y su destreza aumenta en 10 (ya tenía 90, entonces queda en 100)"):-
    destreza(CarpinchoEntrenado, 10):-
        atrapaLaRana(sofy, 10, CarpinchoEntrenado).

test("iii. Kike recorre 30 km en cardioPincho y aumenta su velocidad en 60 (ya tenía 40, entonces queda en 100)"):-
    velocidad(CarpinchoEntrenado,100):-
        cardioPincho(kike,30,CarpinchoEntrenado).

:- end_tests(punto7_Atributos).

:- begin_tests(punto7_carssfit).

test("iv. Alancito entrena 20 minutos en carssFit, aumenta su fuerza y destreza en 10, pero su velocidad baja en 20 (ya tenía (80, 80, 70), entonces queda en (90, 90, 50))"):-
    carpincho(CarpinchoEntrenado, habilidades([correr]), 90, 90, 50):-
        carssFit(alancito, 10, CarpinchoEntrenado).

:- end_tests(punto7_carssfit).

:- begin_tests(punto8).

test("i. Nacho le gana a 5 en cebar mate"):-
    aCuantosLesGana(nacho, cebarMate, 5).

test("ii. Kike le gana a 4 en salto con ramita"):-
    aCuantosLesGana(kike, saltoConRamita, 4).

test("iii. Sofy le gana a 6 en revolver basura"):-
    aCuantosLesGana(sofy, revolverBasura, 6).

:- end_tests(punto8).

:- begin_tests(punto9).

test("i. Sofy la rompe en revolver basura y en huida de depredador"):-
    laRompeEn(sofy,revolverBasura), laRompeEn(sofy,huidaDeDepredador).

test("ii. Contu la rompe en preparación de ensalada"):-
    laRompeEn(contu, preparacionDeEnsalada).

test("iii. Sofy no la rompe en trepada de ligustrina", fail):-
    laRompeEn(sofy,trepadaDeLigustrina).
    
test("iii. Contu no la rompe en invasión de casas", fail):-
    laRompeEn(contu, invasionDeCasas).

:- end_tests(punto9).

:- begin_tests(punto10).

test("i. Un drintim para revolver basura y preparación de ensalada está formado por Sofy y Contu."):-
    drintim([sofy, contu], [revolverBasura, preparacionDeEnsalada]).

test("ii. Un drintim para revolver basura y huida de depredador está formado únicamente por Sofy"):-
    drintim([sofy], [revolverBasura, huidaDeDepredador]).

:- end_tests(punto10).


