:- include(solucion).

:- begin_tests(punto6).

test("i. Nacho le gana a Alancito en cebar mate."):-
    competencia(nacho,alancito,cebarMate, nacho), !. % Utilizo el operador de corte (!) al final de la consulta, para evitar que Prolog busque más soluciones después de encontrar la primera

test("ii. Sofy le gana a Contu en salto con ramita."):-
    competencia(sofy,contu,saltoConRamita, sofy), !. % Utilizo el operador de corte (!) al final de la consulta, para evitar que Prolog busque más soluciones después de encontrar la primera

:- end_tests(punto6).

:- begin_tests(punto7).

test("i. Nacho levanta 100 kg en pesasCarpinchas y su fuerza aumenta en 25 (ya tenía 60, entonces queda en 85)"):-
    fuerza(CarpinchoEntrenado, 85):-
        pesasCarpinchas(nacho, 100, CarpinchoEntrenado).

test("ii. Sofy atrapa 10 ranas en atrapaLaRana y su destreza aumenta en 10 (ya tenía 90, entonces queda en 100)"):-
    destreza(CarpinchoEntrenado, 10):-
        atrapaLaRana(sofy, 10, CarpinchoEntrenado).

test("iii. Kike recorre 30 km en cardioPincho y aumenta su velocidad en 60 (ya tenía 40, entonces queda en 100)"):-
    velocidad(CarpinchoEntrenado,100):-
        cardioPincho(kike,30,CarpinchoEntrenado).

test("iv. Alancito entrena 20 minutos en carssFit, aumenta su fuerza y destreza en 10, pero su velocidad baja en 20 (ya tenía (80, 80, 70), entonces queda en (90, 90, 50))"):-
    carpincho(CarpinchoEntrenado, habilidades([correr]), 90, 90, 50):-
        carssFit(alancito, 10, CarpinchoEntrenado).

:- end_tests(punto7).

:- begin_tests(punto8).

test("i. Nacho le gana a 5 en cebar mate"):-
    aCuantosLesGana(nacho, cebarMate, 5).

test("ii. Kike le gana a 4 en salto con ramita"):-
    aCuantosLesGana(kike, saltoConRamita, 4).

test("iii. Sofy le gana a 6 en revolver basura"):-
    aCuantosLesGana(sofy, revolverBasura, 6).

:- end_tests(punto8).