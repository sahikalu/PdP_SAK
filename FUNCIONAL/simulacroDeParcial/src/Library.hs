module Library where
import PdePreludat
import System.Posix.Internals (fileType)

-- 1

data Pizza = Pizza {
    ingredientes :: [String],
    tamanio :: Number,
    cantidadDeCalorias :: Number
} deriving Show

{-
tamanioPizza :: Number -> Pizza -> Bool
tamanioPizza porciones = (porciones ==) . tamanio

tamanioIndividual :: Pizza -> Bool
tamanioIndividual = tamanioPizza 4

tamanioChica :: Pizza -> Bool
tamanioChica = tamanioPizza 6

tamanioGrande :: Pizza -> Bool
tamanioGrande = tamanioPizza 8

tamanioFamiliar :: Pizza -> Bool
tamanioFamiliar = tamanioPizza 12
-}

-- REVISAR!!!!!!!!!!!
grandeDeMuzza :: Pizza -> Pizza
grandeDeMuzza pizza = pizza {ingredientes = ["Salsa", "Muzzarella", "orégano"], tamanio = 8, cantidadDeCalorias = 350}

-- 2

nivelDeSatisfaccion :: Pizza -> Number
nivelDeSatisfaccion pizza
    | "palmitos" `elem` ingredientes pizza = 0
    | cantidadDeCalorias pizza < 500 = length (ingredientes pizza) * 80
    | otherwise = (length (ingredientes pizza) * 80) / 2

-- 3

valorPizza :: Pizza -> Number -> Number
valorPizza = (*) . tamanio . ((120 *) . (length . ingredientes))

-- 4

-- a
nuevoIngrediente :: String -> Pizza -> Pizza
nuevoIngrediente ingrediente pizza = pizza {ingredientes = ingrediente : ingredientes pizza}

-- b
agrandar :: Pizza -> Pizza
agrandar pizza
    | tamanio pizza == 10 = pizza
    | otherwise = pizza {tamanio = tamanio pizza + 2}

-- c

pizzaMasGrande :: Number -> Number -> Number
pizzaMasGrande = max

agregarSinRepetir :: Eq String => [String] -> [String] -> [String]
agregarSinRepetir base agregados = foldl agregar base agregados
    where agregar base elemento
            | elemento `notElem` base = elemento : base
            | otherwise = base

mezcladita :: Pizza -> Pizza -> Pizza
mezcladita pizza1 pizza2 = Pizza {
    ingredientes = agregarSinRepetir (ingredientes pizza1) (ingredientes pizza2),
    tamanio = tamanio pizza1 `pizzaMasGrande` tamanio pizza2,
    cantidadDeCalorias = ((/2) . cantidadDeCalorias) pizza1 + cantidadDeCalorias pizza2
}

-- 5

type Pedido = [Pizza]

niveldDeSatisfaccionPedido :: Pedido -> Number
niveldDeSatisfaccionPedido = sum . map nivelDeSatisfaccion

-- 6

-- a
pizzeriaLosHijosDePato :: Pedido -> Pedido
pizzeriaLosHijosDePato (pizza : pizzas) = pizza {ingredientes = agregarSinRepetir ["Palmito"] (ingredientes pizza)} : pizzeriaLosHijosDePato pizzas

-- b

pedidoFinal :: [(Pizza, Pizza)] -> [Pizza]
pedidoFinal (par : pares) = uncurry mezcladita par : pedidoFinal pares

pizzeriaElResumen :: Pedido -> Pedido
pizzeriaElResumen pedido
    | ((== 1) . length) pedido = pedido
    | otherwise = pedidoFinal nuevoPedidoDeAPAres
        where pedidoSinPrimero = tail pedido
              nuevoPedidoDeAPAres = zip pedido pedidoSinPrimero

-- c
--pizzeriaEspecial :: [String] -> Pedido -> Pedido
pizzeriaEspecial :: [String] -> [[String]] -> [[String]]
pizzeriaEspecial agregados = map (agregarSinRepetir agregados)

anchoasBasicas :: [[String]] -> [[String]]
anchoasBasicas = pizzeriaEspecial ["Salsa","Anchoas"]

pizzeriaPescadito :: Pedido -> Pedido
pizzeriaPescadito (pedido : pedidos) = pedido {
    ingredientes = anchoasBasicas (ingredientes pedido),
    tamanio = 8,
    cantidadDeCalorias = 270
} : pizzeriaPescadito pedidos

-- d

deplorable :: Number -> Pizza -> Bool
deplorable nivelDeEsqisitez pizza = nivelDeEsqisitez > nivelDeSatisfaccion pizza

pizzeriaGourmet :: Number -> Pedido -> [Bool]
pizzeriaGourmet nivelDeEsqisitez (pedido : pedidos) = filter enviable pedido
    where enviable = not . deplorable nivelDeEsqisitez pedido
    