module Library where
import PdePreludat
import Text.Show.Functions

doble :: Number -> Number
doble numero = numero + numero

{- Lisa Simpson se propuso desarrollar un programa que le permita ayudar a su hermano a vencer a su vecino Todd en un torneo de minigolf. Para hacerlo más interesante, los padres de los niños hicieron una apuesta: el padre del niño que no gane deberá cortar el césped del otro usando un vestido de su esposa.

De los participantes nos interesará el nombre del jugador, el de su padre y sus habilidades (fuerza y precisión). 
-}

-- Modelo inicial
data Jugador = Jugador {
    nombre :: String,
    padre :: String,
    habilidad :: Habilidad
} deriving (Eq, Show)

data Habilidad = Habilidad {
    fuerzaJugador :: Number,
    precisionJugador :: Number
} deriving (Eq, Show)

-- Jugadores de ejemplo
bart :: Jugador
bart = Jugador "Bart" "Homero" (Habilidad 25 60)
todd :: Jugador
todd = Jugador "Todd" "Ned" (Habilidad 15 80)
rafa :: Jugador
rafa = Jugador "Rafa" "Gorgory" (Habilidad 10 1)

data Tiro = Tiro {
    velocidad :: Number,
    precision :: Number,
    altura :: Number
} deriving (Eq, Show)

type Puntos = Number

-- Funciones útiles
between :: (Eq a, Enum a) => a -> a -> a -> Bool
between n m x = x `elem` [n .. m]

maximoSegun :: Ord a1 => (a2 -> a1) -> [a2] -> a2
maximoSegun f = foldl1 (mayorSegun f)

mayorSegun :: Ord a => (t -> a) -> t -> t -> t
mayorSegun f a b
    | f a > f b = a
    | otherwise = b

{- 
1) Sabemos que cada palo genera un efecto diferente, por lo tanto elegir el palo correcto puede ser la diferencia entre ganar o perder el torneo.
    a) Modelar los palos usados en el juego que a partir de una determinada habilidad generan un tiro que se compone por velocidad, precisión y altura.
        i) El putter genera un tiro con velocidad igual a 10, el doble de la precisión recibida y altura 0.
        ii) La madera genera uno de velocidad igual a 100, altura igual a 5 y la mitad de la precisión.
        iii) Los hierros, que varían del 1 al 10 (número al que denominaremos n), generan un tiro de velocidad igual a la fuerza multiplicada por n, la precisión dividida por n y una altura de n-3 (con mínimo 0). Modelarlos de la forma más genérica posible.
-}

type Palo = Habilidad -> Tiro

putter :: Palo
putter habilidad = Tiro {
    velocidad = 10,
    precision = precisionJugador habilidad * 2,
    altura = 0
}

madera :: Palo
madera habilidad = Tiro {
    velocidad = 100,
    altura = 5,
    precision = precisionJugador habilidad `div` 2
}

hierro :: Number -> Palo
hierro n habilidad = Tiro {
    velocidad = fuerzaJugador habilidad * n,
    precision = precisionJugador habilidad `div` n,
    altura = max 0 (n - 3)
}

-- b) Definir una constante palos que sea una lista con todos los palos que se pueden usar en el juego.

palos :: [Palo]
palos = [putter, madera] ++ map hierro [1..10]

{- 2) Definir la función golpe que dados una persona y un palo, obtiene el tiro resultante de usar ese palo con las habilidades de la persona.
Por ejemplo si Bart usa un putter, se genera un tiro de velocidad = 10, precisión = 120 y altura = 0. -}

golpe :: Jugador -> Palo -> Tiro
golpe jugador palo = palo (habilidad jugador)
{-  Es lo mismo que: 
    golpe:: Palo -> (Jugador -> Tiro)
    golpe palo = palo . habilidad
-}

{- 3) Lo que nos interesa de los distintos obstáculos es si un tiro puede superarlo, y en el caso de poder superarlo, cómo se ve afectado dicho tiro por el obstáculo. En principio necesitamos representar los siguientes obstáculos:

Se desea saber cómo queda un tiro luego de intentar superar un obstáculo, teniendo en cuenta que en caso de no superarlo, se detiene, quedando con todos sus componentes en 0.
-}

-- type Obstaculo = Tiro -> Tiro
{- data Obstaculo = UnObstaculo {
    superaObstaculo :: Tiro -> Bool,
    efectoObstaculo :: Tiro -> Tiro
} -}
data Obstaculo = Obstaculo {
    superaObstaculo :: Tiro -> Bool,
    efectoObstaculo :: Tiro -> Tiro
}

tiroDetenido :: Tiro
tiroDetenido = Tiro 0 0 0

{- 
obstaculoSuperableSi condicion efecto tiro
    | condicion tiro = efecto tiro
    | otherwise = tiroDetenido 
-}

intentarSuperarObstaculo :: Obstaculo -> Tiro -> Tiro
intentarSuperarObstaculo obstaculo tiro
    | puedeSuperar obstaculo tiro = efectoObstaculo obstaculo tiro
    | otherwise = tiroDetenido

vaAlRazDelSuelo :: Tiro -> Bool
vaAlRazDelSuelo = (== 0) . altura

-- a) Un túnel con rampita sólo es superado si la precisión es mayor a 90 yendo al ras del suelo, independientemente de la velocidad del tiro. Al salir del túnel la velocidad del tiro se duplica, la precisión pasa a ser 100 y la altura 0.

tunelConRampita :: Obstaculo
tunelConRampita = Obstaculo superaTunelConRampita  efectoTunelConRampita

superaTunelConRampita :: Tiro -> Bool
superaTunelConRampita tiro = precision tiro > 90 && vaAlRazDelSuelo tiro


efectoTunelConRampita :: Tiro -> Tiro
efectoTunelConRampita tiro = Tiro {
    velocidad = velocidad tiro * 2,
    precision = 100,
    altura = 0
    }

-- b) Una laguna es superada si la velocidad del tiro es mayor a 80 y tiene una altura de entre 1 y 5 metros. Luego de superar una laguna el tiro llega con la misma velocidad y precisión, pero una altura equivalente a la altura original dividida por el largo de la laguna.


laguna :: Number -> Obstaculo
laguna largoLaguna = Obstaculo superaLaguna (efectoLaguna largoLaguna)

superaLaguna :: Tiro -> Bool
superaLaguna tiro = velocidad tiro > 80 && (between 1 5 . altura) tiro


efectoLaguna :: Number -> Tiro -> Tiro
efectoLaguna largoLaguna tiro = Tiro {
    velocidad = velocidad tiro,
    precision = precision tiro,
    altura = altura tiro / largoLaguna
}

-- c) Un hoyo se supera si la velocidad del tiro está entre 5 y 20 m/s yendo al ras del suelo con una precisión mayor a 95. Al superar el hoyo, el tiro se detiene, quedando con todos sus componentes en 0.


hoyo :: Obstaculo
hoyo = Obstaculo superaHoyo efectoHoyo

superaHoyo :: Tiro -> Bool
superaHoyo tiro = (between 5 20 . velocidad) tiro && ((> 95) . precision) tiro && vaAlRazDelSuelo tiro


efectoHoyo :: Tiro -> Tiro
efectoHoyo _ = tiroDetenido

-- 4) 
-- a) Definir palosUtiles que dada una persona y un obstáculo, permita determinar qué palos le sirven para superarlo.

palosUtiles :: Jugador -> Obstaculo -> [Palo]
palosUtiles jugador obstaculo = filter (leSirveParaSuperar jugador obstaculo) palos

leSirveParaSuperar :: Jugador -> Obstaculo -> Palo -> Bool
leSirveParaSuperar jugador obstaculo palo = puedeSuperar obstaculo (golpe jugador palo)

puedeSuperar :: Obstaculo -> Tiro -> Bool
puedeSuperar = superaObstaculo

{- b) Saber, a partir de un conjunto de obstáculos y un tiro, cuántos obstáculos consecutivos se pueden superar.
Por ejemplo, para un tiro de velocidad = 10, precisión = 95 y altura = 0, y una lista con dos túneles con rampita seguidos de un hoyo, el resultado sería 2 ya que la velocidad al salir del segundo túnel es de 40, por ende no supera el hoyo.
BONUS: resolver este problema sin recursividad, teniendo en cuenta que existe una función takeWhile :: (a -> Bool) -> [a] -> [a] que podría ser de utilidad.
-}

-- SIN RECURSIVIDAD:
cuantosObstaculosConsecutivosSupera :: Tiro -> [Obstaculo] -> Number
cuantosObstaculosConsecutivosSupera tiro obstaculos = (length . takeWhile (uncurry puedeSuperar) . zip obstaculos . tirosSucesivos tiro) obstaculos

tirosSucesivos :: Tiro -> [Obstaculo] -> [Tiro]
tirosSucesivos tiroOriginal = foldl (\ tirosGenerados obstaculo -> tirosGenerados ++ [intentarSuperarObstaculo obstaculo (last tirosGenerados)]) [tiroOriginal]

{- CON RECURSIVIDAD: 
cuantosObstaculosConsecutivosSupera :: Tiro -> [Obstaculo] -> Number
cuantosObstaculosConsecutivosSupera tiro [] = 0
cuantosObstaculosConsecutivosSupera tiro (obstaculo : obstaculos)
    | puedeSuperar obstaculo tiro = 1 + cuantosObstaculosConsecutivosSupera (efectoObstaculo obstaculo tiro) obstaculos
    | otherwise = 0
-}

-- c) Definir paloMasUtil que recibe una persona y una lista de obstáculos y determina cuál es el palo que le permite superar más obstáculos con un solo tiro.

paloMasUtil :: Jugador -> [Obstaculo] -> Palo
paloMasUtil jugador obstaculos = maximoSegun (flip cuantosObstaculosConsecutivosSupera obstaculos . golpe jugador) palos

-- 5) Dada una lista de tipo [(Jugador, Puntos)] que tiene la información de cuántos puntos ganó cada niño al finalizar el torneo, se pide retornar la lista de padres que pierden la apuesta por ser el “padre del niño que no ganó”. Se dice que un niño ganó el torneo si tiene más puntos que los otros niños.

jugadorDeTorneo :: (Jugador, Puntos) -> Jugador
jugadorDeTorneo = fst

puntosGanados :: (Jugador, Puntos) -> Puntos
puntosGanados = snd

padresQuePierdenLaApuesta :: [(Jugador, Puntos)] -> [String]
padresQuePierdenLaApuesta puntosDeTorneo = map (padre . jugadorDeTorneo) (filter (not . gano puntosDeTorneo) puntosDeTorneo)

gano :: [(Jugador, Puntos)] -> (Jugador, Puntos) -> Bool
gano puntosDeTorneo puntosDeUnJugador = (all ((< puntosGanados puntosDeUnJugador) . puntosGanados ) . filter ( /= puntosDeUnJugador)) puntosDeTorneo