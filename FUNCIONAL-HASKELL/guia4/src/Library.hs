{-# LANGUAGE MonoLocalBinds #-}
module Library where
import PdePreludat
import qualified Data.Type.Bool as True

---------------------------------------------------------------------- LISTAS ----------------------------------------------------------------------

-- 1) Definir una función que sume una lista de números. Nota: Investigar sum

sumarLista :: [Number] -> Number
sumarLista = foldl (+) 0
-- sumarLista lista = foldl (+) 0 lista
-- sumarLista = sum (ES LO MISMO QUE LA FUNCIÓN DEFINIDA ARRIBA)

-- 2) Durante un entrenamiento físico de una hora, cada 10 minutos de entrenamiento se tomóo la frecuencia cardíaca de uno de los participantes obteniéndose un total de 7 muestras que son las siguientes: frecuenciaCardiaca = [80, 100, 120, 128, 130, 123, 125]

{-
    Comienza con un frecuencia de 80 min 0. 
    A los 10 min la frecuencia alcanza los 100
    A los 20 min la frecuencia es de 120,
    A los 30 min la frecuencia es de 128
    A los 40 min la frecuencia es de 130, ...etc..
    A los 60 min la frecuencia es de 125 frecuenciaCardiaca es un función constante.
-}

listaDeFrecuenciaCardiaca :: [Number]
listaDeFrecuenciaCardiaca = [80, 100, 120, 128, 130, 123, 125]

-- a) a. Definir la función promedioFrecuenciaCardiaca, que devuelve el promedio de la frecuencia cardíaca.         Main> promedioFrecuenciaCardiaca            115.285714285714

promedioLista :: [Number] -> Number
promedioLista lista = sumarLista lista / length lista

romedioFrecuenciaCardiaca :: [Number] -> Number
romedioFrecuenciaCardiaca = promedioLista

-- b) Definir la función frecuenciaCardiacaMinuto/1, que recibe m que es el minuto en el cual quiero conocer la frecuencia cardíaca, m puede ser a los 10, 20, 30 ,40,..hasta 60.           Main> frecuenciaCardiacaMomento 30          128

momento :: Number -> Number
momento = (/ 10)
-- momento minuto  = (/ 10) minuto

frecuenciaCardiacaMinuto :: [Number] -> Number -> Number
frecuenciaCardiacaMinuto listaDeFrecuencias minuto = listaDeFrecuencias !! momento minuto

-- c) Definir la función frecuenciasHastaMomento/1, devuelve el total de frecuencias que se obtuvieron hasta el minuto m.           Main> frecuenciasHastaMomento 30            [80, 100, 120, 128]         Ayuda: Utilizar la función take y la función auxiliar definida en el punto anterior.

frecuenciasHastaMomento :: Number -> [Number] -> [Number]
frecuenciasHastaMomento minuto = take posicion
    where posicion = momento minuto + 1
-- frecuenciasHastaMomento minuto listaDeFrecuencias = take (momento minuto) listaDeFrecuencias

-- 3) Definir la función esCapicua/1, si data una lista de listas, me devuelve si la concatenación de las sublistas es una lista capicua..Ej:           Main> esCapicua ["ne", "uqu", "en"]         True.            Porque “neuquen” es capicua. Ayuda: Utilizar concat/1, reverse/1.

esCapicua :: Eq a => [[a]] -> Bool
esCapicua lista = concat lista == reverse (concat lista)

-- 4) Setieneinformacióndetalladadeladuraciónenminutosdelasllamadasque se llevaron a cabo en un período determinado, discriminadas en horario normal y horario reducido.    duracionLlamadas = (("horarioReducido",[20,10,25,15]),(“horarioNormal”,[10,5,8,2, 9,10])).

duracionLlamadas :: ((String, [Number]), (String, [Number]))
duracionLlamadas = (("horarioReducido",[20,10,25,15]),("horarioNormal",[10,5,8,2, 9,10]))

-- a) Definir la función cuandoHabloMasMinutos, devuelve en que horario se habló más cantidad de minutos, en el de tarifa normal o en el reducido.          Main> cuandoHabloMasMinutos         “horarioReducido”

cuandoHabloMasMinutos :: ((String, [Number]), (String, [Number])) -> String
cuandoHabloMasMinutos ((stringDeHorarioReducido, listaDeHorarioReducido), (stringDeHorarioNormal, listaDeHorarioNormal))
    | sumarLista listaDeHorarioReducido > sumarLista listaDeHorarioNormal = stringDeHorarioReducido
    | otherwise = stringDeHorarioNormal

-- b) Definir la función cuandoHizoMasLlamadas, devuelve en que franja horaria realizó más cantidad de llamadas, en el de tarifa normal o en el reducido.           Main> cuandoHizoMasLlamadas         “horarioNormal”.          Nota: Utilizar composición en ambos casos

cuandoHizoMasLlamadas :: ((String, [Number]), (String, [Number])) -> String
cuandoHizoMasLlamadas ((stringDeHorarioReducido, listaDeHorarioReducido), (stringDeHorarioNormal, listaDeHorarioNormal))
    | (length . snd . fst) duracionLlamadas > (length . snd . snd) duracionLlamadas = stringDeHorarioReducido
    | otherwise = stringDeHorarioNormal

------------------------------------------------------------------ ORDEN SUPERIOR ------------------------------------------------------------------

-- 1) Definir la función existsAny/2, que dadas una función booleana y una tupla de tres elementos devuelve True si existe algún elemento de la tupla que haga verdadera la función.            Main> existsAny even (1,3,5)            False.           Main> existsAny even (1,4,7)           True.           porque even 4 da True.           Main> existsAny (0>) (1,-3,7)          True.         porque even -3 es negativo

existsAny :: (t -> Bool) -> (t, t, t) -> Bool
existsAny funcionBooleana (elemento1, elemento2, elemento3) = funcionBooleana elemento1 || funcionBooleana elemento2 || funcionBooleana elemento3

-- 2) Definir la función mejor/3, que recibe dos funciones y un número, y devuelve el resultado de la función que dé un valor más alto. P.ej.   Main> mejor cuadrado triple 1           3.         (pues triple 1 = 3 > 1 = cuadrado 1).            Main> mejor cuadrado triple 5           25.            (pues cuadrado 5 = 25 > 15 = triple 5).          Nota: No olvidar la función max.

mejor :: Ord Number => (t -> Number) -> (t -> Number) -> t -> Number
mejor funcion1 funcion2 numero = max (funcion1 numero) (funcion2 numero)

-- funciones auxiliares punto 2

cuadrado :: Number -> Number
cuadrado numero = numero * numero

triple :: Number -> Number
triple = (3 *)
-- triple numero = 3 * numero

-- 3) Definir la función aplicarPar/2,que recibe una función y un par,y devuelve el par que resulta de aplicar la función a los elementos del par. P.ej.           Main> aplicarPar doble (3,12)           (6,24).          Main> aplicarPar even (3,12)            (False, True).          Main> aplicarPar (even . doble) (3,12)         (True, True)

aplicarPar :: (t -> b) -> (t, t) -> (b, b)
aplicarPar funcion (elemento1, elemento2) = (funcion elemento1, funcion elemento2)

-- funciones auxiliares punto 3

doble :: Number -> Number
doble = (2 *)
-- doble numero = (2 *) numero

-- 4) Definir la función parDeFns/3, que recibe dos funciones y un valor, y devuelve un par ordenado que es el resultado de aplicar las dos funciones al valor. P.ej.           Main> parDeFns even doble 12            (True, 24)

parDeFns :: (t -> a) -> (t -> b) -> t -> (a, b)
parDeFns funcion1 funcion2 valor = (funcion1 valor, funcion2 valor)

-------------------------------------------------------------- ORDEN SUPERIOR + LISTAS --------------------------------------------------------------

-- 1) Definir la función esMultiploDeAlguno/2, que recibe un número y una lista y devuelve True si el número es múltiplo de alguno de los números de la lista. P.ej.            Main> esMultiploDeAlguno 15 [2,3,4]         True.           porque 15 es múltiplo de 3.          Main> esMultiploDeAlguno 34 [3,4,5]         False.           porque 34 no es múltiplo de ninguno de los 3 Nota: Utilizar la función any/2.

esMultiploDeAlguno :: Number -> [Number] -> Bool
esMultiploDeAlguno numero = any (esMultiplo numero)
-- esMultiploDeAlguno numero lista = any (esMultiplo numero) lista

-- funciones auxiliares punto 1
esMultiplo :: Number -> Number -> Bool
esMultiplo divisor dividendo = mod divisor dividendo == 0

-- 2) Armar una función promedios/1, que dada una lista de listas me devuelve la lista de los promedios de cada lista-elemento. P.ej.           Main> promedios [[8,6],[7,9,4],[6,2,4],[9,6]]           [7,6.67,4,7.5].          Nota: Implementar una solución utilizando map/2.

promedios :: [[Number]] -> [Number]
promedios = map promedioLista
-- promedios lista = map promedioLista lista