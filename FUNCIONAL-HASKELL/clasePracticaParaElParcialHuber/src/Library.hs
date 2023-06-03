module Library where
import PdePreludat

{-
data Ubicacion = Interseccion calle1 calle2 | Altura calle número
data Ubicacion = Interseccion String String | Altura String Number deriving (Show, Eq)
-}

data Ubicacion = Interseccion {
    calle1 :: String,
    calle2 :: String
} | Altura {
    calle :: String,
    numero :: Number
} deriving (Show, Eq)


data Persona = Persona {
    edad :: Number,
    tiempoLibre :: Number,
    dineroEncima :: Number
} deriving Show
huberto = Persona 42 10 10.2
leto = Persona 32 20 20

-- colectivos = [(línea, paradas)]
colectivos :: [(Number, [Ubicacion])]
colectivos = [(14,[Interseccion "Salguero" "Lavalle", Interseccion "Salguero" "Potosi",
Interseccion "Bulnes" "Potosi", Altura "Bulnes" 1200]), 
(168,[Altura "Corrientes" 100, Altura "Corrientes" 300, Altura "Corrientes" 500, 
Altura "Corrientes" 700])]

data Huber = Huber {
    origen :: Ubicacion,
    destino :: Ubicacion,
    importe :: Number
} deriving Show

hubers :: [Huber]
hubers = [Huber (Interseccion "Salguero" "Lavalle") (Interseccion "Bulnes" "Potosi") 5,
         Huber (Altura "Av Corrientes" 700) (Interseccion "Sarmiento" "Gallo") 10,
        Huber (Interseccion "Salguero" "Potosi") (Altura "Ecuador" 600) 20,
        Huber (Altura "Corrientes" 300) (Altura "Corrientes" 700) 5,
        Huber (Interseccion "Salguero" "Lavalle") (Altura "Bulnes" 1200) 5]

ubicaciones :: [Ubicacion]
ubicaciones = [ubicacion1, Interseccion "Salguero" "Potosi",
ubicacion2, Interseccion "Sarmiento" "Gallo",
Altura "Ecuador" 600, Altura "Corrientes" 100, Altura "Corrientes" 300, 
Altura "Corrientes" 500, Altura "Corrientes" 700,ubicacion3]

ubicacion1 = Interseccion "Salguero" "Lavalle" 
ubicacion2 = Interseccion “Bulnes” “Potosi”
ubicacion3 = Altura “Bulnes” 1200



