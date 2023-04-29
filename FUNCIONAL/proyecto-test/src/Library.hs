{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Redundant bracket" #-}
module Library where
import PdePreludat
import Test.Hspec (xspecify)
--import qualified GHC.Num as 1


doble :: Number -> Number
doble numero = numero + numero

----------------------- CLASE 4 --------------------------


data Fecha = Fecha {
    dia :: Number,
    mes :: Number,
    anio :: Number
}deriving Show

data Persona = Alumno { nombre :: String, legajo :: Number, notas :: [Number]}
            | Dorente {nombre :: String, curso :: String} deriving Show


-- ejemplo de funciones booleanas para el testing
esPar :: Number -> Bool
esPar = even

-- ejemplo de funciones data para el testing
type Yerba = String
type Temperatura = Number
data Mate = Mate {
    yerba :: Yerba,
    temperatura :: Temperatura
}deriving Show

estaLavado :: Mate -> Bool
estaLavado =  (<= 45) . temperatura


data Fecha1 = Fecha1 {
    dia1 :: Number,
    mes1 :: Number,
    año :: Number
}deriving Show

data Camiseta = Camiseta {
    nombre1 :: String,
    numero :: Number
}deriving Show

-- millenial son los nacidos desde 1981 al 1996
millenial :: Fecha1 -> Bool
millenial fecha = año fecha >= 1981 && año fecha <= 1996

millenials :: [Fecha1] -> [Fecha1]
millenials [] = [] 
millenials (fecha : fechas) 
    | millenial fecha = fecha : millenials fechas
    | otherwise       =  millenials fechas

camisetasPares :: [Camiseta] -> [Camiseta]
camisetasPares [] = []
camisetasPares (camiseta : camisetas)
    | even . numero $ camiseta = camiseta : camisetasPares camisetas
    | otherwise                = camisetasPares camisetas
    -- | (even . numero) camiseta 
    -- | even (numero camiseta) es lo mismo que lo otro
    -- funcion $ se evalua todo lo que esta a la izquierda y todo lo que esta a la derecha. Y finalmente aplico izquierda a derecha

filtro :: (a -> Bool) -> [a] -> [a]
filtro _ [] = []
filtro condicion (x : xs) 
    | condicion x = x : filtro condicion xs
    | otherwise   = filtro condicion xs

mapeo :: (t -> a) -> [t] -> [a]
mapeo _ [] = []
mapeo transformacion (x : xs) = transformacion x : mapeo transformacion xs

-- todos _ [] = True
-- todos condicion (x : xs) = condicion x && todos condicion xs
--todos condicion lista = and . map condicion lista
todos ::  (t -> Bool) -> [t] -> Bool
todos condicion = and1 . mapeo condicion

-- alguno _ [] = False
-- alguno :: (t -> Bool) -> [a] -> Bool
-- alguno condicion (s : xs) = condicion x || alguno condicion xs
alguno :: (t -> Bool) -> [t] -> Bool
alguno condicion = or1 . mapeo condicion

and1 :: [Bool] -> Bool
and1 [] = True
and1 (x : xs) = x && and1 xs

or1 :: [Bool] -> Bool
or1 [] = False
or1 (x : xs) = x || or1 xs


-- ejercicio en clase "maximoSegun f x y"
mayorSegun :: Ord a => (t -> a) -> t -> t -> t
mayorSegun f x y
    | f x > f y = x
    |otherwise = y

-- ejercicio en clase "maximoSegun f lista"
maximoSegun :: Ord a1 => (a2 -> a1) -> [a2] -> a2
-- maximoSegun :: (a -> Number) -> [a] -> a
maximoSegun f [x] = x
maximoSegun f (x1 : x2 : xs) = maximoSegun f (mayorSegun f x1 x2 : xs) -- "(x1 : x2 : xs)" la lista tiene por lo menos 2 elementos

-- ejercicio en clase funcion que concatene 2 listas "concatenar lista1 lista2"
-- lo estandar seria "concatenar lista1 lista2 ++"
concatenar :: [a] -> [a] -> [a]
concatenar [] lista2 = lista2
concatenar (x : xs) lista2 = x : concatenar xs lista2