# ejercicio-alumno

## Consigna [https://docs.google.com/document/d/1ZUoYrTCEKNOPS1HegxuDY5ckMxuOaM1Bv2J8Cts4G2M/edit]

### Consigna
En este contexto tan atípico la gente buscó nuevas maneras de divertirse, pero cuando nada parece funcionar siempre están los viejos y confiables libros. A raíz del renovado interés de la gente por la lectura, la conocida empresa Amazin' nos pidió que le ayudemos a desarrollar parte de sus funcionalidades. 

Parte A
De las personas que tienen una cuenta en Amazin' conocemos su nick, su índice de felicidad, los libros que adquirió y los libros que efectivamente leyó. 

De cada libro conocemos su título, quien lo escribió, su cantidad de páginas y cómo afecta 
el género a las personas que lo lean.

Modelar les usuaries.
Modelar los libros.
Da un ejemplo de usuarie.
Da un ejemplo de libro.

Parte B
Como te contamos más arriba, el género de cada libro produce distintas reacciones en quien los lea:
Las comedias dependen de su tipo de humor:
Las comedias dramáticas no alteran a quien las lee.
Las comedias absurdas aumentan en 5 el índice de felicidad.
Las comedias satíricas duplican el índice de felicidad.
El resto de comedias le suman 10 al índice de felicidad.
Los de ciencia ficción tienen un impacto muy especial, ya que las personas que los leen quieren un nombre raro por lo que invierten los caracteres de su nick.
Los de terror hacen huir con pavor a quienes los leen, por lo que regalan todos sus libros adquiridos, haciendo que abandonen la lectura… PARA SIEMPRE MUAJAJA.

Parte C 
Pero qué sería de una aplicación de libros si no hacemos la lógica para registrar y sacar conclusiones sobre la lectura de los mismos:

Cuando una persona lee un libro el mismo pasa a formar parte de sus libros leídos y además ocurren los efectos del género.
Cuando una persona se pone al día lee todos los libros adquiridos que no haya leído previamente. Decimos que una persona leyó un libro si entre los libros que leyó hay alguno con el mismo título que haya sido escrito por la misma persona.
Algunas personas se fanatizan con quienes escriben los libros, es por ello que queremos saber si una persona es fanática de un escritor o escritora; esto sucede cuando todos los libros que leyó fueron escritos por esa autora o autor. 
¿Puede una persona ponerse al día si adquirió una cantidad infinita de libros? Justificar.

Parte D
Amazin' tiene que clasificar los libros para facilitar las búsquedas, es por ello que decimos que:
Los libros con menos de 100 páginas son cuentos.
Los libros que tengan entre 100 y 200 páginas son novelas cortas. 
Los libros con más de 200 páginas son novelas. 

Para finalizar queremos poder saber los títulos de los libros que una persona adquirió dado un tipo de libro en específico (cuentos, novelas cortas o novelas). 
