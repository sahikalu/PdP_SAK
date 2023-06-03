% los lenguajes coinciden con los implementa, todos son hechos, por lo que puedo usar 
%hechos
lenguaje(haskell).
lenguaje(cpp).
lenguaje(python).
lenguaje(html).
%hechos
implementa(haskell, funcional).
implementa(cpp, imperativo).
implementa(cpp, objetos).
implementa(python, imperativo).
implementa(python, objetos).

lenguajeProgramacion(Lenguaje):- implementa(Lenguaje,_).

lenguaje(Lenguaje):- lenguajeProgramacion(Lenguaje,_). % regla
lenguaje(xml).
lenguaje(html).


lenguajeMultiparadigma(Lenguaje):- 
	implementa(Lenguaje, Paradigma1), % Paradigma1 es una incógnita
	implementa(Lenguaje, Paradigma2), % Paradigma2 es una incógnita 
	Paradigma1 \= Paradigma2. % condicion a cumplir

