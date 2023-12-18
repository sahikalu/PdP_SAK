module Library where
import PdePreludat

doble :: Number -> Number
doble numero = numero + numero

miAldea :: Aldea
miAldea = Aldea { poblacion = 100, materialesDisponibles = [(Material "Acero" 15), (Material "Piedra" 5)], edificios = [(Edificio "Barracas" [(Material "Acero" 20)]), (Edificio "Concorcity" [(Material "Marmol" 30)])] }

aldeaRica :: Aldea
aldeaRica = Aldea { poblacion = 100, materialesDisponibles = [(Material "Comida" 15), (Material "Comida" 5), (Material "Comida" 6), (Material "Comida" 6)], edificios = [(Edificio "Barracas" [(Material "Acero" 20)]), (Edificio "Concorcity" [(Material "Marmol" 30)])] }

aldeaPobre :: Aldea
aldeaPobre = Aldea { poblacion = 100, materialesDisponibles = [(Material "Comida" 15), (Material "Madera" 5), (Material "Cemento" 6), (Material "Comida" 6)], edificios = [(Edificio "Barracas" [(Material "Acero" 20)]), (Edificio "Concorcity" [(Material "Marmol" 30)])] }

aldeaDeMadera :: Aldea
aldeaDeMadera = Aldea { poblacion = 30, materialesDisponibles = [(Material "Madera" 15), (Material "Madera" 5)], edificios = []}

{- ejemploB :: Aldea
ejemploB = Aldea { poblacion = 50,  materialesDisponibles = [(Material "Acero" 15), (Material "Acero" 20), (Material "Piedra" 5)] , edificios = [] }

ejemploC :: Aldea
ejemploC = Aldea{ poblacion = 50,  materialesDisponibles = [(Material "Acero" 15), (Material "Piedra" 5)], edificios = [(Edificio "Barracas" [(Material "Acero" 20)])] }
 -}
data Material = Material {
    nombre :: String,
    calidad :: Number
} deriving (Show, Eq)

data Edificio = Edificio {
    tipoEdificio :: String,
    materiales :: [Material]
} deriving (Show, Eq)

data Aldea = Aldea {
    poblacion :: Number,
    materialesDisponibles :: [Material],
    edificios :: [Edificio]
} deriving (Show, Eq)

{- 1. Desarrollar las siguientes funciones:
    a. esValioso que recibe un material y retorna true si su calidad es mayor a 20
        > esValioso (Material "Madera de pino" 25)
        True
-}

esValioso :: Material -> Bool
esValioso = (> 20) . calidad

{- b. unidadesDisponibles que recibe el nombre de un material y una aldea y retorna la cantidad de materiales disponibles con ese nombre en la aldea
        > unidadesDisponibles "Acero" (Aldea 50 [(Material "Acero" 15), (Material "Acero" 20), (Material "Piedra" 5)] [])
        2
-}

unidadesDisponibles :: String -> Aldea -> Number
unidadesDisponibles nombreMaterial = length . filter esMaterialBuscado . materialesDisponibles
    where esMaterialBuscado material = nombre material == nombreMaterial

{- c. valorTotal recibe una aldea y retorna la suma de la calidad de todos los materiales que hay en la aldea. Estos son tanto los disponibles como los usados en sus edificios.
        > valorTotal (Aldea 50 [(Material "Acero" 15), (Material "Piedra" 5)] [(Edificio "Barracas" [(Material "Acero" 20)])])
        40
-}

todosLosMateriales :: Aldea -> [Material]
todosLosMateriales aldea = concatMap materiales (edificios aldea) ++ materialesDisponibles aldea
-- concatMap Concatena los resultados de aplicar una función a cada elemento de una lista.

valorTotal :: Aldea -> Number
valorTotal = sum . map calidad . todosLosMateriales
-- valorTotal aldea = sum . map calidad . todosLosMateriales $ aldea

-- 2. Desarrollar las siguientes tareas para que los gnomos puedan realizar en una aldea:

type Tarea = Aldea -> Aldea

-- a. tenerGnomito que aumenta la población de la aldea en 1.
tenerGnomito :: Tarea
tenerGnomito aldea = aldea { poblacion = (+ 1 ) . poblacion $ aldea  }

-- b. lustrarMaderas que aumenta en 5 la calidad de todos los materiales disponibles cuyo nombre empiece con la palabra “Madera”. El resto de los materiales disponibles de la aldea no deberían verse afectados al realizar esta tarea.

lustrarMaderas :: Tarea
lustrarMaderas aldea = aldea { materialesDisponibles = map lustrarMadera . materialesDisponibles $ aldea }
    where lustrarMadera material | nombre material == "Madera" = material { calidad = calidad material + 5 }
                                 | otherwise = material

{- c. recolectar que dado un material y una cantidad de cuánto de ese material se quiere recolectar, incorpore a los materiales disponibles de la aldea ese mismo material tantas veces como se indique.
    > recolectar (Material "Acero" 15) 5 (Aldea 50 [] [])
    Aldea {poblacion = 50, materialesDisponibles = [Material {nombre = "Acero", calidad = 15},Material {nombre = "Acero", calidad = 15},Material {nombre = "Acero", calidad = 15},Material {nombre = "Acero", calidad = 15},Material {nombre = "Acero", calidad = 15}], edificios = []}
-}
recolectar :: Material -> Number -> Tarea
recolectar material cantidad aldea = aldea { materialesDisponibles = materialesDisponibles aldea ++ replicate cantidad material }

-- 3. Realizar las consultas que permitan:
-- a. Obtener los edificios chetos de una aldea, que son aquellos que tienen algún material valioso.

obtenerEdificiosChetos :: Aldea -> [Edificio]
obtenerEdificiosChetos = filter tieneMaterialValioso . edificios
    where tieneMaterialValioso = any esValioso . materiales
-- obtenerEdificiosChetos aldea = filter tieneMaterialValioso . edificios $ aldea

-- b. Obtener una lista de nombres de materiales comunes, que son aquellos que se encuentran en todos los edificios de la aldea.

intersect :: Eq a => [a] -> [a] -> [a]
intersect lista1 lista2 = filter (`elem` lista2) lista1

primerosMaterialesDeEdificios :: [Edificio] -> [Material]
primerosMaterialesDeEdificios [] = []
primerosMaterialesDeEdificios ( edificio : _ ) = materiales edificio

materialesEnEdificios :: [Edificio] -> [Material]
materialesEnEdificios = concatMap materiales


nombresMaterialesComunes aldea = foldl (intersect . nombresDeMAterialesDeEdificio) listaDeNombreDePimerEdificio edificiosDeAldea
    where edificiosDeAldea = edificios aldea
          nombresMateriales = map nombre
          listaDeNombreDePimerEdificio = nombresMateriales . primerosMaterialesDeEdificios
          nombresDeMAterialesDeEdificio = map nombre . materiales

{- 
obtenerMaterialesComunes aldea = map nombre . filter esMaterialComun . materialesDisponibles $ aldea
    where esMaterialComun material = all (== material) . map nombre . materiales . edificios $ aldea  
    -}


-- 4.
-- a. Definir la función realizarLasQueCumplan::[Tarea]->(Aldea->Bool)->Aldea->Aldea, que recibe una lista de tareas, un criterio que debería cumplir la aldea luego de realizar cada tarea y la aldea inicial, y retorne cómo quedaría la aldea si se realizaran las tareas válidas, una tras otra. Una tarea es válida si, después de realizarse sobre una aldea (la original o la resultante de haber realizado otra tarea previa), la misma cumple con el criterio indicado.

realizarLasQueCumplan :: [Tarea] -> (Aldea -> Bool) -> Aldea -> Aldea
realizarLasQueCumplan tareas criterio aldea = foldl (realizarTarea criterio) aldea tareas

realizarTarea :: (Aldea -> Bool) -> Aldea -> Tarea -> Aldea
realizarTarea criterio aldea tarea
    | criterio (tarea aldea) = tarea aldea
    | otherwise = aldea

{- b. Hacer consultas utilizando realizarLasQueCumplan de forma tal que:
    i. Se tengan gnomitos 3 veces (como 3 tareas independiente entre sí), asegurando que siempre haya más unidades de comida disponible que la cantidad de población en la aldea luego de realizar cada tarea de tener gnomitos. Un material con el nombre “Comida” se considera una unidad de comida. 
    ii. Se recolecten 30 unidades de madera de pino de calidad igual a la calidad máxima de las maderas disponibles y luego se lustren las maderas disponibles de la aldea, asegurando siempre que todos los materiales disponibles sean valiosos. 
-}

tieneMasComidaQuePoblacion :: Aldea -> Bool
tieneMasComidaQuePoblacion aldea = (> poblacion aldea) . unidadesDisponibles "Comida" $ aldea

todosLosMaterialesValiosos :: Aldea -> Bool
todosLosMaterialesValiosos = all esValioso . todosLosMateriales