# ejercicio-alumno
[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-24ddc0f5d75046c5622901739e7c5dd533143b0c8e959d652212380cedb1ea36.svg)](https://classroom.github.com/a/QDgbVTjZ)
[![Open in Visual Studio Code](https://classroom.github.com/assets/open-in-vscode-718a45dd9cf7e7f842a935f5ebbe5719a5e09af4491e668f4dbf3b35d5cca122.svg)](https://classroom.github.com/online_ide?assignment_repo_id=11319646&assignment_repo_type=AssignmentRepo)
# Parcial de Funcional - 10/06/2023

## [Enunciado](https://docs.google.com/document/d/1MIzx4nvbrLbAJjmoDDtyDBVI5luUHfU_4_UnUaCpZdc/edit?usp=sharing)


### ENUNCIADO:
Las carreras de autos pueden ser muy divertidas, pero tienen consecuencias. En esta edición de parcial vamos a analizar y producir los efectos que sufren los autos al correr una carrera. Los autos se componen de marca, modelo, desgaste (ruedas y chasis, son dos números), velocidad máxima (m/s), y el tiempo de carrera, que lo vamos a considerar inicialmente 0 y tendremos en cuenta luego el uso.

Una pista está compuesta de distintas partes (curvas, rectas, boxes), donde cada tramo termina realizando una transformación sobre el auto que la atraviesa.

Nota: Maximizar el uso de aplicación parcial, composición y orden superior. No usar recursividad a menos que se indique que está permitido.

1. Modelar el auto, teniendo en cuenta la información necesaria que lo representa. Y luego representar:
    a. Auto Ferrari, modelo F50, sin desgaste en su chasis y ruedas, con una velocidad máxima de 65 m/s.
    b. Auto Lamborghini, modelo Diablo, con desgaste 7 de chasis y 4 de ruedas, con una velocidad máxima de 73 m/s.
    c. Auto Fiat, modelo 600, con desgaste 33 de chasis y 27 de ruedas, con una velocidad máxima de 44 m/s.


2. Estado de salud del auto:
    a. Saber si un auto está en buen estado, esto se da cuando el desgaste del chasis es menor a 40 y el de las ruedas es menor 60.
    b. Saber si un auto no da más, esto ocurre si alguno de los valores de desgaste es mayor a 80.

3. Reparar un Auto: la reparación de un auto baja en un 85% el desgaste del chasis (es decir que si esta en 50, lo baja a 7.5) y deja en 0 el desgaste de las ruedas.

4. Modelar las funciones para representar las distintas partes de una pista, teniendo en cuenta:
    a. La curva tiene dos datos relevantes: el ángulo y la longitud. Al atravesar una curva, el auto sufre un desgaste en sus ruedas que responde a la siguiente cuenta: 
1 / angulo * 3 * Longitud.
        i. Suma un tiempo de longitud / ( velocidad máxima / 2 )
        ii. Modelar curvaPeligrosa, que es una curva de ángulo 60 y longitud de 300m
        iii. Modelar curvaTranca, que es una curva de ángulo 110 y longitud de 550m

    b. El tramo recto, debido a la alta velocidad se afecta el chasis del auto en una centésima parte de la longitud del tramo.
        i. Suma un tiempo de longitud / velocidad máxima
        ii. Modelar tramoRectoClassic de 750m
        iii. Modelar tramito de 280m

    c. Cuando pasa por un tramo Boxes, si está en buen estado, solo pasa por el tramo que compone Boxes, en el caso contrario debe repararse:
        i. En el caso de estar en buen estado, suma el tiempo del tramo que lo compone
        ii. En caso contrario suma 10 segundos de penalización al tiempo del tramo


    d. Ya sea por limpieza o lluvia a veces hay una parte de la pista (cualquier parte) que está mojada. Suma la mitad de tiempo agregado por el tramo.

    e. Algunos tramos tienen ripio (sí... está un poco descuidada la pista) y produce el doble de efecto de un tramo normal equivalente, y se tarda el doble en atravesarlo también. Nos aclaran que, por suerte, nunca hay boxes con ripio.

    f. Los tramos que tienen alguna obstrucción, además, producen un desgaste en las ruedas de acuerdo a la porción de pista ocupada, siendo 2 puntos de desgaste por cada metro de pista que esté ocupada, producto de la maniobra que se debe realizar al esquivar dicha obstrucción.

Nota: Atención con la repetición de lógica en este punto.

5. Realizar la función pasarPorTramo/2 que, dado un tramo y un auto, hace que el auto atraviese el tramo, siempre y cuando no pase que no dá más.

6. Teniendo en cuenta que una pista es una sucesión de tramos: 
    a. Crear la superPista con los siguientes tramos:
        i. tramoRectoClassic
        ii. curvaTranca
        iii. 2 tramitos consecutivos, pero el primero está mojado
        iv. Curva con ángulo de 80º, longitud 400m; con obstrucción de 2m
        v. Curva con ángulo de 115º, longitud 650m
        vi. Tramo recto de 970m
        vii. curvaPeligrosa
        viii. tramito con ripio
        ix. Boxes con un Tramo Recto de 800m
    b. Hacer la función peganLaVuelta/2 que dada una pista y una lista de autos, hace que todos los autos den la vuelta (es decir, que avancen por todos los tramos), teniendo en cuenta que un auto que no da más “deja de avanzar”.


7. ¡¡Y llegaron las carreras!!
    a. Modelar una carrera que está dada por una pista y un número de vueltas.
    b. Representar el tourBuenosAires, una carrera que se realiza en la superPista y tiene 20 vueltas.
    c. Hacer que una lista de autos juegue una carrera, teniendo los resultados parciales de cada vuelta, y la eliminación de los autos que no dan más en cada vuelta.

8. Dada la siguiente función…..
myPrecious ts x = sum . map (($ snd x) . snd) . filter ((>5) . length . fst x) $ ts
Explicar el tipo de la función de acuerdo a su definición.
