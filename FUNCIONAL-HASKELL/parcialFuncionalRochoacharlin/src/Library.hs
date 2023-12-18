{-# OPTIONS_GHC -Wno-unrecognised-pragmas #-}
{-# HLINT ignore "Eta reduce" #-}
module Library where
import PdePreludat

doble :: Number -> Number
doble numero = numero + numero

-- 1. Modelar el auto, teniendo en cuenta la información necesaria que lo representa. Y luego representar:
data Auto = Auto{
    marca :: String,
    modelo :: String,
    desgasteDeChasis :: Number,
    desgasteDeRuedas :: Number,
    velocidadMax :: Number,
    tiempoDeCarrera :: Number
} deriving Show

-- a. Auto Ferrari, modelo F50, sin desgaste en su chasis y ruedas, con una velocidad máxima de 65 m/s.
ferrari :: Auto
ferrari = Auto "Ferrari" "F50" 0 0 65 0
-- b. Auto Lamborghini, modelo Diablo, con desgaste 7 de chasis y 4 de ruedas, con una velocidad máxima de 73 m/s.
lamborghini :: Auto
lamborghini = Auto "Lamborghini" "Diablo" 7 4 73 0
-- c. Auto Fiat, modelo 600, con desgaste 33 de chasis y 27 de ruedas, con una velocidad máxima de 44 m/s.
fiat :: Auto
fiat = Auto "Fiat" "600" 33 27 44 0

-- 2. Estado de salud del auto:
-- a. Saber si un auto está en buen estado, esto se da cuando el desgaste del chasis es menor a 40 y el de las ruedas es menor 60.
estaEnBuenEstado :: Auto -> Bool
estaEnBuenEstado auto = ((< 40) . desgasteDeChasis) auto && ((< 60) . desgasteDeRuedas) auto

-- b. Saber si un auto no da más, esto ocurre si alguno de los valores de desgaste es mayor a 80.
noDaMas :: Auto -> Bool
noDaMas auto = ((> 80) . desgasteDeChasis) auto || ((> 80) . desgasteDeRuedas) auto

-- 3. Reparar un Auto: la reparación de un auto baja en un 85% el desgaste del chasis (es decir que si esta en 50, lo baja a 7.5) y deja en 0 el desgaste de las ruedas.
desgastarChasis :: Number -> Auto -> Auto
desgastarChasis desgaste auto = auto{ desgasteDeChasis = (+ desgaste) . desgasteDeChasis $ auto }
desgastarRuedas :: Number -> Auto -> Auto
desgastarRuedas desgaste auto = auto{ desgasteDeRuedas = (+ desgaste) . desgasteDeRuedas $ auto}

reparar :: Auto -> Auto
reparar auto = desgastarRuedas (negate . desgasteDeRuedas $ auto) . desgastarChasis (negate (85 * desgasteDeChasis auto / 100)) $ auto

-- 4. Modelar las funciones para representar las distintas partes de una pista, teniendo en cuenta:
-- Nota: Atención con la repetición de lógica en este punto.

type Parte = Auto -> Auto
type Pista = [Parte]

sumarTiempo :: Number ->Parte
sumarTiempo tiempo auto = auto{ tiempoDeCarrera = (+ tiempo) . tiempoDeCarrera $ auto }

parte :: Parte -> Number -> Parte
parte desgasteQueProduce tiempoQueToma = sumarTiempo tiempoQueToma . desgasteQueProduce
-- parte desgasteQueProduce tiempoQueToma auto = sumarTiempo tiempoQueToma.desgasteQueProduce $ auto 

{- a. La curva tiene dos datos relevantes: el ángulo y la longitud. Al atravesar una curva, el auto sufre un desgaste en sus ruedas que responde a la siguiente cuenta: 
1 / angulo * 3 * Longitud.
    i. Suma un tiempo de longitud / ( velocidad máxima / 2 )
    ii. Modelar curvaPeligrosa, que es una curva de ángulo 60 y longitud de 300m
    iii. Modelar curvaTranca, que es una curva de ángulo 110 y longitud de 550m
-}
curva :: Number -> Number -> Parte
curva angulo longitud auto = parte desgaste tiempo auto
    where
        desgaste = desgastarRuedas (1 / (angulo * 7 * longitud))
        tiempo = (longitud /) . (/ 2) . velocidadMax $ auto

curvaPeligrosa :: Parte
curvaPeligrosa = curva 60 300

curvaTranca :: Parte
curvaTranca = curva 110 550

{- b. El tramo recto, debido a la alta velocidad se afecta el chasis del auto en una centésima parte de la longitud del tramo.
    i. Suma un tiempo de longitud / velocidad máxima
    ii. Modelar tramoRectoClassic de 750m
    iii. Modelar tramito de 280m
-}
tramoRecto :: Number -> Parte
tramoRecto longitud auto = parte desgaste tiempo auto
    where
        desgaste = desgastarChasis . (/ 100) . desgasteDeChasis $ auto
        tiempo = (longitud /) . velocidadMax $ auto

tramoRectoClassic :: Parte
tramoRectoClassic = tramoRecto 750

tramito :: Parte
tramito = tramoRecto 280

{- c. Cuando pasa por un tramo Boxes, si está en buen estado, solo pasa por el tramo que compone Boxes, en el caso contrario debe repararse:
    i. En el caso de estar en buen estado, suma el tiempo del tramo que lo compone
    ii. En caso contrario suma 10 segundos de penalización al tiempo del tramo
-}
boxes :: Parte -> Parte
boxes tramo auto
    | estaEnBuenEstado auto = tramo auto
    | otherwise             = sumarTiempo 10 . reparar . tramo $ auto

-- d. Ya sea por limpieza o lluvia a veces hay una parte de la pista (cualquier parte) que está mojada. Suma la mitad de tiempo agregado por el tramo.
tramoMojado :: Parte -> Parte
tramoMojado tramo auto = sumarTiempo (tiempoAgregadoPorTramo / 2) . tramo $ auto
    where tiempoAgregadoPorTramo = (tiempoDeCarrera . tramo) auto - tiempoDeCarrera auto

-- e. Algunos tramos tienen ripio (sí... está un poco descuidada la pista) y produce el doble de efecto de un tramo normal equivalente, y se tarda el doble en atravesarlo también. Nos aclaran que, por suerte, nunca hay boxes con ripio.
tramoConRipio :: Parte -> Parte
tramoConRipio tramo = tramo . tramo

-- f. Los tramos que tienen alguna obstrucción, además, producen un desgaste en las ruedas de acuerdo a la porción de pista ocupada, siendo 2 puntos de desgaste por cada metro de pista que esté ocupada, producto de la maniobra que se debe realizar al esquivar dicha obstrucción.
tramoConObstruccion :: Number -> Parte -> Parte
-- tramoConObstruccion largoDeObstruccion tramo auto = desgasteProducido.tramo $ auto
tramoConObstruccion largoDeObstruccion tramo = desgasteProducido . tramo
    where desgasteProducido = desgastarChasis (2 * largoDeObstruccion)

-- 5. Realizar la función pasarPorTramo/2 que, dado un tramo y un auto, hace que el auto atraviese el tramo, siempre y cuando no pase que no dá más.
pasarPorTramo :: Parte -> Parte
pasarPorTramo tramo auto
    | not . noDaMas $ auto = tramo auto
    | otherwise = auto

{- 6. Teniendo en cuenta que una pista es una sucesión de tramos: 
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
-}
superPista :: Pista
superPista = [tramoRectoClassic, curvaTranca, tramito . tramoMojado tramito, tramoConObstruccion 2 (curva 80 400),
    curva 115 650, tramoRecto 970, curvaPeligrosa, tramoConRipio tramito, boxes (tramoRecto 800)]

-- b. Hacer la función peganLaVuelta/2 que dada una pista y una lista de autos, hace que todos los autos den la vuelta (es decir, que avancen por todos los tramos), teniendo en cuenta que un auto que no da más “deja de avanzar”.
peganLaVuelta :: Pista -> [Auto] -> [Auto]
-- peganLaVuelta pista autos = map pegaLaVuelta autos
peganLaVuelta pista = map pegaLaVuelta
    where pegaLaVuelta auto = foldr pasarPorTramo auto . reverse $ pista

-- 7. ¡¡Y llegaron las carreras!!
-- a. Modelar una carrera que está dada por una pista y un número de vueltas.
data Carrera = Carrera{
    pista :: Pista,
    nroDeVueltas :: Number
}

-- b. Representar el tourBuenosAires, una carrera que se realiza en la superPista y tiene 20 vueltas.
tourBuenosAires :: Carrera
tourBuenosAires = Carrera superPista 20

-- c. Hacer que una lista de autos juegue una carrera, teniendo los resultados parciales de cada vuelta, y la eliminación de los autos que no dan más en cada vuelta.

-- TODO: flip peganLaVuelta autos tendría que haber sido foldl (flip peganLaVuelta) autos

hacerCarrera :: Carrera -> [Auto] -> [[Auto]]
hacerCarrera carrera autos = map (quitarALosQueNoDanMas . resultadosDeLaVuelta) [1 .. nroDeVueltas carrera]
    where
        resultadosDeLaVuelta nroDeVuelta = foldl (flip peganLaVuelta) autos . flip take (pista carrera) $ nroDeVuelta
        quitarALosQueNoDanMas autosQueCorrieron = filter (not . noDaMas) autosQueCorrieron
        -- resultadosDeLaVuelta nroDeVuelta = flip peganLaVuelta autos. flip take (pista carrera) $ nroDeVuelta
        -- quitarALosQueNoDanMas autosQueCorrieron = filter (not.noDaMas) autosQueCorrieron


-- TODO : HERMOSOOOO!! Excelente explicación de la inferencia, lo unico que faltó fue decir qué pasa con los demás tipos (a y c), que basta con decir que no hay informacion suficiente para inferir de que tipo son o si están relacionados con otro tipo.
{-- 8

myPrecious ts x = 
	sum . map (($ snd x) . snd) . filter ((>5) . length . fst x) $ ts

myPrecious :: [(a, c -> Number)] -> ( (a, c -> Number) -> [b] , c ) -> Number

1) Salida
    myPrecious es una composición cuya última función es sum. Por lo tanto, myPrecious devuelve un número.

2) 2do parámetro: x
    A x se le aplica fst en una ocasión y snd en otra. x es una tupla.
    El 1er elemento de la tupla ha de ser una función, pues forma parte de una composición. Esta función
    debe esperar un elemento de ts y transformarlo en una lista, por el length que se aplica luego.
    El 2do elemento de la tupla es argumento del 2do elemento de los elementos de ts.

3) 1er parámetro: ts
    filter está aplicada parcialmente y es la primera en la composición. Como se le pasa ts, ts debe ser una lista.
    A cada elemento de ts se le puede aplicar snd, visto en la función de map. Cada elemento es una tupla.
    El 2do elemento de la tupla es una función que recibe el 2do elemento de x y lo transforma en un número,
    pues map debe darle una lista de números a sum.
--}
