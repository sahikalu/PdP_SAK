module Library where
import PdePreludat

-- APLICACIÓN PARCIAL --------------------------------------------------------------------------------------------------------------------

-- 1) Definir una función siguiente, que al invocarla con un número cualquiera me devuelve el resultado de sumar a ese número el 1.  Main> siguiente 3     4

siguiente :: Number -> Number
siguiente = (+) 1
-- siguiente numero = (+) 1 numero

-- 2) Definir una función mitad, que al invocarla con un número cualquiera me devuelve la mitad de ese número.  Main> mitad 5     2.5

mitad :: Number -> Number
mitad = ( / 2 )
-- mitad numero = ( / 2 ) numero

-- 3) Definir una función inversa, que invocando a la función con un número cualquiera me devuelva su inversa.  Main> inversa 4     0.25             Main> inversa 0.5       2.0

inversa :: Number -> Number
inversa = (^ (-1))
--inversa numero = (^ (-1)) numero

-- 4) Definir una función triple, que invocando a la función con un número cualquiera me devuelva el triple del mismo. Main> triple 5      15
triple :: Number -> Number
triple = (3 *)
-- triple numero = 3 * numero

-- 5) Definir una función esNumeroPositivo, que invocando a la función con un número cualquiera me devuelva true si el número es positivo y false en caso contrario. Main> esNumeroPositivo (-5)        False           Main> esNumeroPositivo 0.99          True

esNumeroPositivo :: Number -> Bool
esNumeroPositivo = (> 0)
-- esNumeroPositivo numero = (> 0) numero

-- COMPOSICIÓN---------------------------------------------------------------------------------------------------------------------------

-- 6) Resolver la función del ejercicio 2 de la guía anterior esMultiploDe/2, utilizando aplicación parcial y composición.
-- 

esMultiploDe :: Number -> Number -> Bool
esMultiploDe dividendo = (== 0) . mod dividendo
-- esMultiploDe dividendo divisor = (== 0) . mod dividendo divisor

-- 7) Resolver la función del ejercicio 5 de la guía anterior esBisiesto/1, utilizando aplicación parcial y composición.
{- 5) Definir la función esBisiesto/1, indica si un año es bisiesto. (Un año es bisiesto si es divisible por 400 o es divisible por 4 pero no es divisible por 100) Nota: Resolverlo reutilizando la función esMultiploDe/2
esBisiesto :: Number -> Bool
esBisiesto anio
    | esMultiploDe 400 anio = True
    | esMultiploDe 100 anio = False
    | esMultiploDe 4 anio = True
    | otherwise = False

esBisiesto :: Number -> b
esBisiesto = (esMultiploDe 400 || esMultiploDe 4) && not(esMultiploDe 100) $ anio
-}

-- 8) Resolver la función inversaRaizCuadrada/1, que da un número n devolver la inversa su raíz cuadrada.Main> inversaRaizCuadrada 4        0.5 Nota: Resolverlo utilizando la función inversa Ej. 2.3, sqrt y composición.

inversaRaizCuadrada :: Number -> Number
inversaRaizCuadrada = inversa . sqrt
-- inversaRaizCuadrada numero = inversa . sqrt $ numero

-- 9) Definir una función incrementMCuadradoN, que invocándola con 2 números m y n, incrementa un valor m al cuadrado de n por Ej:Main> incrementMCuadradoN 3 2     11 Incrementa 2 al cuadrado de 3, da como resultado 11. Nota: Resolverlo utilizando aplicación parcial y composición.
-- incrementMCuadradoN