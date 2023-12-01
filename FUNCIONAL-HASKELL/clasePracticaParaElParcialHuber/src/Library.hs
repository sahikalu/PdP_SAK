{-# OPTIONS_GHC -Wno-missing-fields #-}
module Library where
import PdePreludat
import Control.Monad (when)

{-
Alumna: Sahira Aylén Alvarez Kalustian
Legajo: 175.584-5
-}

-- Los autos se componen de marca, modelo, desgaste (ruedas y chasis, son dos números), velocidad máxima (m/s), y el tiempo de carrera, que lo vamos a considerar inicialmente 0 y tendremos en cuenta luego el uso.

data Auto = Auto {
    marca :: String,
    modelo :: String,
    desgaste :: (Chasis, Ruedas),
    velocidadMaxima :: Number,
    tiempoDeCarrera :: Number
} deriving (Show, Eq)

type Chasis = Number
type Ruedas = Number

-- 1) Modelar el auto, teniendo en cuenta la información necesaria que lo representa. Y luego representar:
-- a) Auto Ferrari, modelo F50, sin desgaste en su chasis y ruedas, con una velocidad máxima de 65 m/s.

ferrari :: Auto
ferrari = Auto {
    marca = "Ferrari",
    modelo = "F50",
    desgaste = (0, 0),
    velocidadMaxima = 65,
    tiempoDeCarrera = 0
}

-- b) Auto Lamborghini, modelo Diablo, con desgaste 7 de chasis y 4 de ruedas, con una velocidad máxima de 73 m/s.

lamborghini :: Auto
lamborghini = Auto {
    marca = "Lamborghini",
    modelo = "Diablo",
    desgaste = (7, 4),
    velocidadMaxima = 73,
    tiempoDeCarrera = 0
}

-- c) Auto Fiat, modelo 600, con desgaste 33 de chasis y 27 de ruedas, con una velocidad máxima de 44 m/s.

fiat :: Auto
fiat = Auto {
    marca = "Fiat",
    modelo = "600",
    desgaste = (33, 27),
    velocidadMaxima = 44,
    tiempoDeCarrera = 0
}

-- 2) Estado de salud del auto:
-- a) Saber si un auto está en buen estado, esto se da cuando el desgaste del chasis es menor a 40 y el de las ruedas es menor 60.

autoEstaEnBuenEstado :: Auto -> Bool
autoEstaEnBuenEstado auto = fst (desgaste auto) < 40 && snd (desgaste auto) < 60

-- b) Saber si un auto no da más, esto ocurre si alguno de los valores de desgaste es mayor a 80.

autonoDaMas :: Auto -> Bool
autonoDaMas auto = fst (desgaste auto) > 80 || snd (desgaste auto) > 80

-- 3) Reparar un Auto: la reparación de un auto baja en un 85% el desgaste del chasis (es decir que si esta en 50, lo baja a 7.5) y deja en 0 el desgaste de las ruedas.

modificarDesgasteAuto :: Auto -> (Chasis -> Chasis) -> (Ruedas -> Ruedas) -> Auto
modificarDesgasteAuto auto@(Auto _ _ (chasis, ruedas) _ _) modificacionChasis modificacionRuedas = auto { desgaste = (modificacionChasis chasis, modificacionRuedas ruedas) }

repararAuto :: Auto -> Auto
repararAuto auto@(Auto _ _ (chasis, ruedas) _ _) = auto { desgaste = (porcentaje chasis 15, 0) }
    where porcentaje numero porcentaje = (numero * porcentaje) / 100

-- 4) Modelar las funciones para representar las distintas partes de una pista, teniendo en cuenta:
-- a) La curva tiene dos datos relevantes: el ángulo y la longitud. Al atravesar una curva, el auto sufre un desgaste en sus ruedas que responde a la siguiente cuenta:  1 / angulo * 7 * Longitud.

type Angulo = Number
type Longitud = Number

type Curva = (Angulo, Longitud)

atravesarCurva :: Curva -> Auto -> Auto
atravesarCurva curva@(angulo, longitud) auto@(Auto _ _ (chasis, ruedas) _ _) = modificarDesgasteAuto auto id desgasteEnRuedas
    where desgasteEnRuedas curva = 1 / angulo * 7 * longitud

-- I) Suma un tiempo de longitud / ( velocidad máxima / 2 )

{-
modificarTiempoEnCarrera :: (a -> a) -> Auto -> Auto
modificarTiempoEnCarrera modificacionTiempo auto = auto { tiempoDeCarrera = modificacionTiempo (tiempoDeCarrera auto)}

sumarTiempoEnLongitud :: Curva -> Auto -> Auto
sumarTiempoEnLongitud (angulo, longitud) auto = modificarTiempoEnCarrera (nuevoTiempo (angulo, longitud)) auto
    where nuevoTiempo (angulo, longitud) = tiempoDeCarrera auto + (longitud / (velocidadMaxima auto / 2))
-}

sumarTiempoEnLongitud :: Curva -> Auto -> Auto
sumarTiempoEnLongitud (angulo, longitud) auto = auto { tiempoDeCarrera = tiempoDeCarrera auto + (longitud / (velocidadMaxima auto / 2))}

-- II) Modelar curvaPeligrosa, que es una curva de ángulo 60 y longitud de 300m

curvaPeligrosa :: Curva
curvaPeligrosa = (60, 300)

-- III) Modelar curvaTranca, que es una curva de ángulo 110 y longitud de 550m

curvaTranca :: Curva
curvaTranca = (110, 550)

-- b) El tramo recto, debido a la alta velocidad se afecta el chasis del auto en una centésima parte de la longitud del tramo.

type Tramo = Curva

tramoRecto :: Number -> Auto -> Auto
tramoRecto tramo auto = modificarDesgasteAuto auto desgasteEnChasis id
    where desgasteEnChasis tramo = fst (desgaste auto) + (tramo / 100)

-- I) Suma un tiempo de longitud / velocidad máxima

modificarTiempoEnCarrera :: (Number -> Number) -> Auto -> Auto
modificarTiempoEnCarrera modificacionTiempo auto = auto { tiempoDeCarrera = modificacionTiempo (tiempoDeCarrera auto)}

sumarTiempoEnLongitudTramoRecto :: Curva -> Auto -> Auto
sumarTiempoEnLongitudTramoRecto tramo@(0, longitud) auto = modificarTiempoEnCarrera nuevoTiempo auto
    -- auto { tiempoDeCarrera = tiempoDeCarrera auto + (longitud / velocidadMaxima auto) }
    where nuevoTiempo tramo = tiempoDeCarrera auto + (longitud / velocidadMaxima auto)

-- II) Modelar tramoRectoClassic de 750m

tramoRectoClassic :: Tramo
tramoRectoClassic = (0, 750)

-- III) Modelar tramito de 280m

tramito :: Tramo
tramito = (0, 280)

-- c) Cuando pasa por un tramo Boxes, si está en buen estado, solo pasa por el tramo que compone Boxes, en el caso contrario debe repararse:
-- I) En el caso de estar en buen estado, suma el tiempo del tramo que lo compone
-- II) En caso contrario suma 10 segundos de penalización al tiempo


penalizacion :: Number -> Number
penalizacion tiempoDeCarrera = tiempoDeCarrera + 10

tramoPasaPorBoxes :: Tramo -> Auto -> Auto
tramoPasaPorBoxes tramo auto
    | autoEstaEnBuenEstado auto = sumarTiempoEnLongitud tramo auto
    | otherwise = modificarTiempoEnCarrera (penalizacion (tiempoDeCarrera auto)) auto

-- c) Ya sea por limpieza o lluvia a veces hay una parte de la pista (cualquier parte) que está mojada. Suma la mitad de tiempo agregado por el tramo.

pistaMojada :: Auto -> Auto
pistaMojada auto = modificarTiempoEnCarrera (sumoMitad (tiempoDeCarrera auto)) auto
    where sumoMitad tiempoDeCarrera = tiempoDeCarrera / 2

-- e) Algunos tramos tienen ripio (sí... está un poco descuidada la pista) y además de producir el efecto en sí mismo, produce el doble de efecto de un tramo normal equivalente, y se tarda el doble en atravesarlo también. Nos aclaran que, por suerte, nunca hay boxes con ripio.


ripio :: Tramo -> Auto -> Auto
ripio (angulo,longitud) auto = auto {
    desgaste = (desgasteEnChasis longitud, desgasteEnRuedas longitud),
    tiempoDeCarrera = tiempoDeCarrera auto + (longitud / velocidadMaxima auto * 2)
}
    where desgasteEnChasis tramo = fst (desgaste auto) + (tramo / 100) * 2
          desgasteEnRuedas tramo = snd (desgaste auto) * 2

-- e) Los tramos que tienen alguna obstrucción, además, producen un desgaste en las ruedas de acuerdo a la porción de pista ocupada, siendo 2 puntos de desgaste por cada metro de pista que esté ocupada, producto de la maniobra que se debe realizar al esquivar dicha obstrucción.
-- Nota: Atención con la repetición de lógica en este punto.


tramoObstruido :: Tramo -> Number -> Auto -> Auto
tramoObstruido tramo@(_, longitud) ocupacion auto = auto {
    desgaste = (desgasteEnChasis longitud, desgasteEnRuedas tramo ocupacion),
    tiempoDeCarrera = tiempoDeCarrera auto + (longitud / velocidadMaxima auto)
}
    where desgasteEnChasis tramo = fst (desgaste auto) + (tramo / 100)
          desgasteEnRuedas tramo ocupacion = snd (desgaste auto) + (2 * ocupacion)

-- 5) Realizar la función pasarPorTramo/2 que, dado un tramo y un auto, hace que el auto atraviese el tramo, siempre y cuando no pase que no dá más.

pasarPorTramo :: (Auto -> Auto) -> Auto -> Auto
pasarPorTramo tramo auto
    | autoEstaEnBuenEstado auto = tramo auto
    | otherwise = auto

-- 6) Teniendo en cuenta que una pista es una sucesión de tramos: 

type Pista = [Tramo]

-- a) Crear la superPista con los siguientes tramos:
-- I) tramoRectoClassic


-- II) curvaTranca
-- III) 2 tramitos consecutivos, pero el primero está mojado
-- VI) Curva con ángulo de 80º, longitud 400m; con obstrucción de 2m
-- V) Curva con ángulo de 115º, longitud 650m
-- VI) Tramo recto de 970m
-- VII) curvaPeligrosa
-- VIII) tramito con ripio
-- IX) Boxes con un Tramo Recto de 800m
