module Library where
import PdePreludat

-- GUIA 1 -----------------------------------

-- 1) Definir la función esMultiploDeTres/1, que devuelve True si un número es múltiplo de 3, p.ej: Main> esMultiploDeTres 9     es   True
esMultiploDeTres :: Number -> Bool
esMultiploDeTres dividendo = esMultiploDe 3 dividendo

-- 2) Definir la función esMultiploDe/2, que devuelve True si el segundo es múltiplo del primero, p.ej. Main> esMultiplo 12 3     es   True
esMultiploDe :: Number -> Number -> Bool
esMultiploDe divisor dividendo = dividendo `mod` divisor == 0

-- 3) Definir la función cubo/1, devuelve el cubo de un número.
cubo :: Number -> Number
cubo x = x ^ 3

-- 4) Definir la función area/2, devuelve el área de un rectángulo a partir de su base y su altura.
area :: Number -> Number -> Number
area base altura = base * altura

-- 5) Definir la función esBisiesto/1, indica si un año es bisiesto. (Un año es bisiesto si es divisible por 400 o es divisible por 4 pero no es divisible por 100) Nota: Resolverlo reutilizando la función esMultiploDe/2
esBisiesto :: Number -> Bool
esBisiesto anio
    | esMultiploDe 400 anio = True
    | esMultiploDe 100 anio = False
    | esMultiploDe 4 anio = True
    | otherwise = False
-- esBisiesto anio = esMultiploDe anio 400 || (not (esMultiploDe anio 100)) && esMultiploDe anio 4 || otherwise = False

-- 6) Definir la función celsiusToFahr/1, pasa una temperatura en grados Celsius a grados Fahrenheit.
celsiusToFahr :: Number -> Number
celsiusToFahr celcius = (celcius * 1.8) + 32

-- 7) Definir la función fahrToCelsius/1, la inversa de la anterior.
fahrToCelsius :: Number -> Number
fahrToCelsius fahr = (fahr - 32) / 1.8

-- 8) Definir la función haceFrioF/1, indica si una temperatura expresada en grados Fahrenheit es fría. Decimos que hace frío si la temperatura es menor a 8 grados Celsius.
haceFrioF :: Number -> String
haceFrioF fahr
    | (fahrToCelsius fahr) < 8 = "Hace frio"
    | otherwise = "No hace frio"

-- 9) Definir la función mcm/2 que devuelva el mínimo común múltiplo entre dos números, de acuerdo a esta fórmula. m.c.m.(a, b) = {a * b} / {m.c.d.(a, b)} . Más información. Nota: Se puede utilizar gcd (es el mcd).
mcm :: Number -> Number -> Number
mcm a b = (a * b) / (gcd a b)

-- 10) Trabajamos con tres números que imaginamos como el nivel del río Paraná a la altura de Corrientes medido en tres días consecutivos; cada medición es un entero que representa una cantidad de cm. P.ej. medí los días 1, 2 y 3, las mediciones son: 322 cm, 283 cm, y 294 cm. A partir de estos tres números, podemos obtener algunas conclusiones. Definir estas funciones:

-- a) dispersion, que toma los tres valores y devuelve la diferencia entre el más alto y el más bajo. Ayuda: extender max y min a tres argumentos, usando las versiones de dos elementos. De esa forma se puede definir dispersión sin escribir ninguna guarda (las guardas están en max y min, que estamos usando).

max3 :: Ord a => a -> a -> a -> a
max3 val1 val2 = max (max val1 val2)

min3 :: Ord a => a -> a -> a -> a
min3 val1 val2 = min (min val1 val2)

dispersion :: Number -> Number -> Number -> Number
dispersion val1 val2 val3 = max3 val1 val2 val3  - min3 val1 val2 val3

-- b) diasParejos, diasLocos y diasNormales reciben los valores de los tres días. Se dice que son días parejos si la dispersión es chica, que son días locos si la dispersión es grande, y que son días normales si no son ni parejos ni locos. Una dispersión se considera chica si es de menos de 30 cm, y grande si es de más de un metro. Nota: Definir diasNormales a partir de las otras dos, no volver a hacer las cuentas.
diasParejos :: Number -> Number -> Number -> Bool
diasParejos val1 val2 val3 = dispersion val1 val2 val3 < 30

diasLocos :: Number -> Number -> Number -> Bool
diasLocos val1 val2 val3 = dispersion val1 val2 val3 > 100

diasNormales :: Number -> Number -> Number -> Bool
diasNormales val1 val2 val3 =  (diasParejos val1 val2 val3) && (diasLocos val1 val2 val3)

-- 11) En una plantación de pinos, de cada árbol se conoce la altura expresada en cm. El peso de un pino se puede calcular a partir de la altura así: 3 kg x cm hasta 3 metros, 2 kg x cm arriba de los 3 metros. P.ej. 2 metros ⇒ 600 kg, 5 metros ⇒ 1300 kg. Los pinos se usan para llevarlos a una fábrica de muebles, a la que le sirven árboles de entre 400 y 1000 kilos, un pino fuera de este rango no le sirve a la fábrica. Para esta situación:

-- a) Definir la función pesoPino, recibe la altura de un pino y devuelve su peso.
pesoPino :: Number -> Number
pesoPino altura
    | altura <= 3 = (altura * 100) * 3
    | altura > 3 = (altura * 100) * 2

-- b) Definir la función esPesoUtil, recibe un peso en kg y devuelve True si un pino de ese peso le sirve a la fábrica, y False en caso contrario.
esPesoUtil :: Number -> Bool
esPesoUtil peso = (peso >= 400) && (peso <= 1000)

-- c) Definir la función sirvePino, recibe la altura de un pino y devuelve True si un pino de ese peso le sirve a la fábrica, y False en caso contrario. Usar composición en la definición
sirvePino :: Number -> Bool
sirvePino altura = esPesoUtil (pesoPino altura)

-- 12) Este ejercicio alguna vez se planteó como un Desafío Café con Leche: Implementar la función esCuadradoPerfecto/1, sin hacer operaciones con punto flotante. Ayuda: les va a venir bien una función auxiliar, tal vez de dos parámetros. Pensar que el primer cuadrado perfecto es 0, para llegar al 2do (1) sumo 1, para llegar al 3ro (4) sumo 3, para llegar al siguiente (9) sumo 5, después sumo 7, 9, 11 etc.. También algo de recursividad van a tener que usar.
esCuadrado :: Number -> Number -> Bool
esCuadrado n raiz = ((raiz ^ 2) == n) || esCuadrado n (raiz + 1)

esCuadradoPerfecto :: Number -> Bool
esCuadradoPerfecto n = esCuadrado n 1