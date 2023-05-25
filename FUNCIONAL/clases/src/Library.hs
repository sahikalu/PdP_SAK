{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}

{-# HLINT ignore "Use concatMap" #-}
module Library where

import Control.Monad (when)
import PdePreludat
import System.Environment (getEnvironment)

-- import qualified Data.Either as 3

{-
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

-- CLASE 5 ------------------------------------------------------------------------------------------------------------------------------------

-- Casino royale
palos :: [String]
palos = ["Corazones", "Picas", "Tréboles", "Diamantes"]

type Carta = (Number, String)

type Cartas = [Carta]

-- En el caso de los jugadores, se constituyen por: su nombre,
-- la mano que están jugando y el nombre de su bebida preferida.

data Jugador = Jugador
  { nombre :: String,
    mano :: Cartas,
    bebida :: String
  }
  deriving (Show)

{-
James Bond (el bueno), cuyo nombre es "Bond... James Bond", tiene un poker de ases y toma "Martini... shaken, not stirred".
Le Chiffre (el malo), que tiene un full de jokers y toma Gin.
Felix Leiter, que tiene una pierna de nueves. Su bebida preferida es el Whisky.
-}
jamesBond :: Jugador
jamesBond = Jugador "Bond... James Bond" pokerDeAses "Martini... shaken, not stirred"

pokerDeAses :: [(Number, String)]
pokerDeAses = [(1, "Corazones"), (1, "Picas"), (1, "Tréboles"), (1, "Diamantes"), (10, "Diamantes")]

leChiffre :: Jugador
leChiffre = Jugador "Le Chiffre" fullDeJokers "Gin"

fullDeJokers :: [(Number, String)]
fullDeJokers = [(11, "Corazones"), (11, "Picas"), (11, "Tréboles"), (10, "Diamantes"), (10, "Picas")]

felixLeiter :: Jugador
felixLeiter = Jugador "Felix Leiter" piernaDeNueves "Whisky"

piernaDeNueves :: [(Number, String)]
piernaDeNueves = [(9, "Corazones"), (9, "Picas"), (9, "Tréboles"), (10, "Diamantes"), (4, "Copas")]

mesaQueMasAplauda :: [Jugador]
mesaQueMasAplauda = [jamesBond, leChiffre, felixLeiter]

-- 1.a
mayorSegun :: Ord a => (t -> a) -> t -> t -> t
mayorSegun f valor1 valor2
  | f valor1 > f valor2 = valor1
  | otherwise = valor2

-- 1.b
maximoSegun :: Ord a1 => (a2 -> a1) -> [a2] -> a2
maximoSegun _ [x] = x
maximoSegun f (x : y : xs) = maximoSegun f (mayorSegun f x y : xs)

-- maximoSegun' :: Ord a1 => (a2 -> a1) -> [a2] -> a2
-- maximoSegun' f = foldl1 (mayorSegun f)
-- maximoSegun f (x:y:xs)
--   | mayorSegun f x y == x = maximoSegun f (x:xs)
--  | otherwise = maximoSegun f (y:xs)

-- 1.c
sinRepetidos :: Eq a => [a] -> [a]
sinRepetidos [] = []
sinRepetidos (x : xs) = x : sinRepetidos (filter (/= x) xs)

-- 2.a
esoNoSeVale :: (Number, String) -> Bool
esoNoSeVale = not . esoSeVale

esoSeVale :: (Number, String) -> Bool
esoSeVale (numero, palo) = elem numero [1 .. 13] && elem palo palos

-- 2.b
-- manoNegra jugador = ((/=5).length.mano) jugador || (any esoNoSeVale.mano $ jugador)
-- ($) f p = f p
manoNegra :: Jugador -> Bool
manoNegra (Jugador _ cartas _) = ((/= 5) . length) cartas || any esoNoSeVale cartas

ocurrenciasDe :: Eq a => a -> [a] -> Number
ocurrenciasDe x = length . filter (== x)

-- 3.a
numero :: (a, b) -> a
numero = fst

palo :: (a, b) -> b
palo = snd

par :: [(Number, String)] -> Bool
par = aparece 2

aparece :: Number -> [(Number, String)] -> Bool
aparece n cartas = any ((n ==) . flip ocurrenciasDe numeros) [1 .. 13]
    where numeros = map numero cartas

aparece' :: Number -> [(Number, String)] -> Bool
aparece' n cartas = any (\num -> n == ocurrenciasDe num numeros) [1 .. 13]
    where numeros = map numero cartas

-- flip f a b = f b a
-- 3.b
pierna :: [(Number, String)] -> Bool
pierna = aparece 3

-- CLASE 6 ------------------------------------------------------------------------------------------------------------------------
-- seguimos con casino royale

-- 3.c
color :: [Carta] -> Bool
color (carta : cartas) = all ((== palo carta) . palo) cartas

-- 3.d
fullHouse :: [(Number, String)] -> Bool
fullHouse cartas = par cartas && pierna cartas

fullHouse' :: [(Number, String)] -> Bool
fullHouse' = flip all [par, pierna] . flip ($)

-- 3.e
poker :: [(Number, String)] -> Bool
poker = aparece 4

-- 3.f
otro :: p -> Bool
otro _ = True

-- 4
alguienSeCarteo :: [Jugador] -> Bool
alguienSeCarteo mesa = sinRepetidos todasLasCartas /= todasLasCartas
    where todasLasCartas = concat . map mano $ mesa

-- 5.a
valores :: [([(Number, String)] -> Bool, Number)]
valores = [(par, 1), (pierna, 2), (color, 3), (fullHouse, 4), (poker, 5), (otro, 0)]

valor :: [(Number, String)] -> Number
valor mano = snd . maximoSegun snd . filter (($ mano) . fst) $ valores

-- 5.b
bebidaWinner :: [Jugador] -> String
bebidaWinner = bebida . maximoSegun (valor . mano) . filter (not . manoNegra)

-- 6

-- 6.a ) El nombre del jugador que está tomando la bebida de nombre más largo.
-- > nombre . maximoSegun (length . bebida) $ mesaQueMasAplauda

-- 6.b ) El jugador (entero, no sólo el nombre) con mayor cantidad de cartas inválidas.
-- >

-- 6.c ) El jugador de nombre más corto.
-- >

-- 6.d ) El nombre del ganador de una mesa, que es aquel del jugador con el juego de mayor valor.
-- >

-- 7.a
ordenar :: (a -> a -> Bool) -> [a] -> [a]
ordenar _ [] = []
ordenar criterio (x : xs) = anteriores ++ [x] ++ posteriores
    where aplica param = ordenar criterio (filter (param . criterio x) xs)
          anteriores = aplica not
          posteriores = aplica id

-- 7.b
escalera :: [(Number, String)] -> Bool
escalera mano = numerosOrdenados == [head numerosOrdenados .. head numerosOrdenados + 4]
    where numerosOrdenados = ordenar (<) . map numero $ mano

escaleraDeColor :: [(Number, String)] -> Bool
escaleraDeColor mano = escalera mano && color mano

{-
all :: (a -> Bool) -> [a] -> Bool
all f xs = foldl condicion True xs
    where condicion s e = s && f e
-}
-}

-- CLASE 7 ------------------------------------------------------------------------------------------------------------------------

-- Ejercicio FedEx

-- 1) Crear el modelo necesario que mejor se adapte para la solución. Además:
data Envio = Envio {
    origen :: Locacion,
    destino :: Locacion,
    peso :: Number,
    precioBase :: Number,
    categorias :: [Categorias],
    impuestos :: [Impuestos]
} deriving Show

data Locacion = Locacion {
    pais :: String,
    ciudad :: String
} deriving (Show, Eq)

type Categorias = String

-- a) Indique el tipo de un cargo.
-- type Cargo = Envio -> Number
type Cargo = Envio -> Envio

-- b) Indique el tipo de un impuesto.
type Impuestos = Envio -> Envio

-- 2) Modelar con funciones constantes: 
-- a) Un cargo categórico de “tecnología” de 18%. 
{-
cagoCategorico :: Categorias -> Number -> Envio -> Envio
cagoCategorico categoria porcentaje envio
    | elem categoria . categorias $ envio = envio { precioBase = precioBase envio * (1 + porcentaje / 100)}
    | otherwise = envio
-}
cagoCategorico :: Categorias -> Number -> Envio -> Envio
-- cagoCategorico categoria porcentaje envio = aplicarCargo (elem categoria . categorias) (porcentaje / 100) envio
cagoCategorico categoria porcentaje = aplicarCargo (elem categoria . categorias) (porcentaje / 100)


cargoTecnologia :: Envio -> Envio
cargoTecnologia = cagoCategorico "tecnologia" 18

cargoSobrepeso :: Number -> Envio -> Envio
cargoSobrepeso pesoLimite envio
    | peso envio > pesoLimite = envio { precioBase = precioBase envio + (peso envio - pesoLimite) * 80}
    | otherwise = envio

aplicarCargo :: (Envio -> Bool) -> Number -> Envio -> Envio
aplicarCargo condicion monto envio
    | condicion envio = envio { precioBase = precioBase envio + monto }
    | otherwise = envio


-- b) Envío con origen en Buenos Aires, Argentina y con destino Utrecht, Países Bajos, de 2 kg. de peso, precio base de $220, con las categorías de música y tecnología, sin impuestos. 

-- envioInternacional
-- envioLocal


-- c) Envío con origen California, Estados Unidos y con destino Miami, Estado Unidos, de 5 kg. de peso, precio base $1500, con categoría de libros, y con IVA e impuesto extraño.




-- 8) 8. Escribir el tipo de la siguiente función:

whatever :: Eq b => b -> (a -> b) -> (b -> [a] -> c) -> [a] -> c
whatever a b c = c a . filter ((a==) . b)