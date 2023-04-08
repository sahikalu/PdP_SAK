module Library where
import PdePreludat

doble :: Number -> Number
doble numero = numero + numero

funcionLoca :: a -> String -> Number
funcionLoca x y = 15

esMultiploDe :: Number -> Number -> Bool
esMultiploDe divisor dividendo = mod dividendo divisor == 0

esBisiesto :: Number -> Bool
esBisiesto anio
    | esMultiploDe 400 anio= True
    | esMultiploDe 100 anio = False
    | esMultiploDe 4 anio = True
    | otherwise = False

-- esBisiesto anio = esMultiploDe anio 400 || (not (esMultiploDe anio 100)) && esMultiploDe anio 4 || otherwise = False
