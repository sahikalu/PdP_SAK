{-# LANGUAGE MonoLocalBinds #-}
module Library where
import PdePreludat
import Control.Monad (when)

---------------------------------------------------------------------- CurryCoin -----------------------------------------------------------------------
{-

-- 1) a) Modelar los tipos de los bloques, las transacciones y las cuentas. Nota: Tener en cuenta lo comentado en 1.b para las transacciones.

type Id = String

data Cuenta = Cuenta{
    idCuenta :: Id,
    saldo :: Number
} deriving (Show, Eq)

type Transaccion = Cuenta -> Cuenta

type Bloque = [(Id, Transaccion)]

-- 1) b) Las transacciones... Para simplificar el modelo, el intercambio estará separado en transacciones de cobro y pago:

transaccion :: Number -> Transaccion
transaccion numero cuenta = cuenta {saldo = saldo cuenta + numero}

-- I) Hacer una función de pago, que reciba un número y una cuenta, y devuelva la cuenta con esa cantidad menos de Currycoins.

pago :: Number -> Transaccion
pago numero = transaccion (- numero)

-- II) Hacer una función de cobranza, que reciba un número y una cuenta, y devuelva la cuenta con esa cantidad más de Currycoins.

cobranza :: Number -> Transaccion
cobranza = transaccion

-- III) Hacer una función de minería, que reciba una cuenta y la devuelva con 25 Currycoins más.
-- Nota: No repetir lógica

mineria :: Transaccion
mineria = transaccion 25

-- 2) Necesitamos funciones que busquen una cuenta en una lista de cuentas:
-- a) Hacer una función que dado un identificador y una cuenta, nos indique si el identificador corresponde a esa cuenta.

idCorrespondeACuenta :: Id -> Cuenta -> Bool
idCorrespondeACuenta identidicador cuenta = idCuenta cuenta == identidicador

-- b) Hacer una función que dada una condición y una lista de cuentas, devuelva la primera cuenta que cumple la condición.

primeraQueCumpleCondicion :: (Cuenta -> Bool) -> [Cuenta] -> Cuenta
primeraQueCumpleCondicion condicion = head . filter condicion

-- c) Hacer una función que dada una condición y una lista de cuentas, devuelva la lista de cuentas SIN la primera cuenta que cumpla la condición.

sinPrimeraQueCumpleCondicion :: (Cuenta -> Bool) -> [Cuenta] -> [Cuenta]
sinPrimeraQueCumpleCondicion condicion cuentas = takeWhile (/= primera) cuentas ++ tail (dropWhile (/= primera) cuentas)
    where primera = primeraQueCumpleCondicion condicion cuentas

-- 3) Hacer una función que reciba un identificador, una lista de cuentas y una función que modifique una cuenta. De manera que devuelva la lista de cuentas, pero con la cuenta correspondiente al identificador modificada por la función. Las demás cuentas deben permanecer sin cambios. Nota: No hace falta conservar el orden original de la lista

modificoPrimerCuentaQueCumpleCondicion :: Id -> [Cuenta] -> Transaccion -> [Cuenta]
modificoPrimerCuentaQueCumpleCondicion identificador cuentas funcionodificadora = sinPrimeraQueCumpleCondicion (idCorrespondeACuenta identificador) cuentas ++ [funcionodificadora (primeraQueCumpleCondicion (idCorrespondeACuenta identificador) cuentas)]

-- 4) Queremos saber como un bloque afecta a una lista de cuentas. Hacer una función que reciba esas dos cosas y devuelva la lista de cuentas con todas las transacciones ejecutadas.

aplicoBloque :: [(Id, Transaccion)] -> [Cuenta] -> [Cuenta]
aplicoBloque bloque cuentas = foldl aplicarTransaccion cuentas bloque
    where aplicarTransaccion cuentas (identificador, transaccion) = modificoPrimerCuentaQueCumpleCondicion identificador cuentas transaccion

-- 5) Pero... ¡Esperen!... Necesitamos verificar que las cuentas sean estables. Con este fin, hacer una función que reciba una lista de cuentas y nos indique si todas tienen un saldo de Currycoins mayor o igual a cero.

cuentaEsEstable :: [Cuenta] -> Bool
cuentaEsEstable = all ((>= 0) . saldo)

-- 6) Nota: Se puede usar recursividad en este punto (aunque no es necesario). 
-- Hacer un chequeo de una blockchain: necesitamos una función que reciba una blockchain y una lista de cuentas, y ejecute las transacciones de los bloques sobre la lista de cuentas y nos indique si todos los estados intermedios de las cuentas (es decir, tras aplicar cada bloque) son estables.

type Blockchain = [Bloque]

chequeoDeBlockchain :: [[(Id, Transaccion)]] -> [Cuenta] -> [Bool]
chequeoDeBlockchain blockchain cuentas = map (cuentaEsEstable . flip aplicoBloque cuentas) blockchain

-}

---------------------------------------------------------------------- Huber -----------------------------------------------------------------------
{-
--data Ubicacion = Intersección calle1 calle2 | Altura calle número
data Ubicacion =
    Interseccion String String
    | Altura String Number
    deriving (Show, Eq)

data Persona = Persona {
    edad :: Number,
    tiempoLibre :: Number,
    dineroEncima :: Number
} deriving Show

huberto = Persona 42 10 10.2
leto = Persona 32 20 20

--colectivos = [(línea, paradas)]
colectivos :: [(Number, [Ubicacion])]
colectivos = [(14,[Interseccion "Salguero" "Lavalle", Interseccion "Salguero" "Potosi", Interseccion "Bulnes" "Potosi", Altura "Bulnes" 1200]),
    (168,[Altura "Corrientes" 100, Altura "Corrientes" 300, Altura "Corrientes" 500, Altura "Corrientes" 700])]

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

ubicacion1, ubicacion2, ubicacion3 :: Ubicacion
ubicacion1 = Interseccion "Salguero" "Lavalle"
ubicacion2 = Interseccion "Bulnes" "Potosi"
ubicacion3 = Altura "Bulnes" 1200

estanOrdenadas :: Eq t => t -> t -> [t] -> Bool
estanOrdenadas u1 u2 lista = indexOf u1 lista < indexOf u2 lista

indexOf :: Eq t => t -> [t] -> Number
indexOf e lista = recIndexOf 1 e lista

recIndexOf :: Eq t => Number -> t -> [t] -> Number
recIndexOf _ _ [] = 0 -- es feo :)
recIndexOf index e (x:xs)
    | e==x = index
    | otherwise = recIndexOf (index+1) e xs

-- También se cuenta con la función estanOrdenadas/3, que dadas dos ubicaciones y una lista, determina si la primera ubicación (primer parámetro) aparece antes en la lista que la segunda ubicación (segundo parámetro). Si alguna de las dos ubicaciones no aparece en la lista, o si no respetan el orden, devolverá False. Esta función puede utilizarse siempre que sea conveniente.

estanOrdenadas' :: Eq t => t -> t -> [t] -> Bool
estanOrdenadas' ubicacion1 ubicacion2 lista = indexOf ubicacion1 lista < indexOf ubicacion2 lista

-- Definir las funciones requeridas, reutilizando las propias funciones y las del Prelude siempre que sea posible, sin repetir lógica. Además, no se puede usar recursividad en ningún punto excepto que se especifique lo contrario. Debe usarse al menos una vez composición, orden superior, aplicación parcial, funciones lambda y listas por comprensión.

-- 1) importeEnHuber/2, que dadas dos ubicaciones devuelva el precio de ir desde la primera ubicación hacia la segunda. Si no hay algún huber que realice dicho viaje, entonces devolver cero.          > importeEnHuber ubicacion1 ubicacion2          5

huberHAceViajeEnHuber :: Ubicacion -> Ubicacion -> Bool
huberHAceViajeEnHuber ubicacion1 ubicacion2 = any (\huber -> origen huber == ubicacion1 && destino huber == ubicacion2) hubers

importeEnHuber :: Ubicacion -> Ubicacion -> Number
importeEnHuber ubicacionSalida ubicacionLlegada
    | huberHAceViajeEnHuber ubicacionSalida ubicacionLlegada = importe (head (filter (\huber -> origen huber == ubicacionSalida && destino huber == ubicacionLlegada) hubers))
    | otherwise = 0

-- 2) sePuedeIrEnBondi/2 que dadas dos ubicaciones, determine si existe una línea que vaya de la primera ubicación a la segunda (es decir, la primera ubicación es una parada de la línea, previa a la parada correspondiente a la segunda ubicación).          > sePuedeIrEnBondi ubicacion1 ubicacion3            True

hacerViajeEnBondi :: Eq Ubicacion => Ubicacion -> Ubicacion -> (Number, [Ubicacion]) -> Bool
hacerViajeEnBondi ubicacionSalida ubicacionLlegada (linea, paradas) = estanOrdenadas ubicacionSalida ubicacionLlegada paradas

sePuedeIrEnBondi :: Ubicacion -> Ubicacion -> Bool
sePuedeIrEnBondi ubicacionSalida ubicacionLlegada = any (hacerViajeEnBondi ubicacionSalida ubicacionLlegada) colectivos

-- 3) masBaratasQueHuber/2 que recibe dos ubicaciones, y devuelve las líneas de colectivos cuyo viaje desde la primera ubicación hacia la segunda ubicación sea más barato que el mismo viaje en un Huber. El valor del colectivo es en relación directa a la cantidad de paradas. En la actualidad, es de $2 por parada.           > masBaratasQueHuber ubicacion1 ubicacion2          [14]

masBaratasQueHuber :: Ubicacion -> Ubicacion -> [Number]
masBaratasQueHuber ubicacionSalida ubicacionLlegada = map fst . filter condicion $ colectivos
    where condicion colectivo = hacerViajeEnBondi ubicacionSalida ubicacionLlegada colectivo && importeEnHuber ubicacionSalida ubicacionLlegada < precioBondi colectivo
          precioBondi (linea, paradas) = 2 * length paradas

-- 4) a) distanciaEntre/3 que dadas dos ubicaciones y una lista de “paradas” (que también son ubicaciones), determine la distancia en cuadras entre ambas ubicaciones. La distancia entre paradas es constante, de 4 cuadras.           > distanciaEntre ubicacion1 ubicacion2 ubicaciones          8

distanciaEntre :: Eq Ubicacion => Ubicacion -> Ubicacion -> [Ubicacion] -> Number
distanciaEntre ubicacionSalida ubicacionLlegada paradas = abs (indexOf ubicacionSalida paradas - indexOf ubicacionLlegada paradas) * 4

-- 4) b) Para la siguiente consulta, indicar la opción correcta y justificar:

    -- > distanciaEntre ubicacion1 ubicacion2 head . map snd . drop 2 $ colectivos

-- I) La función termina de evaluarse, y devuelve un resultado (si se marca como correcta, decir que resultado arroja y cómo llegó a él).
-- II) La función termina de evaluarse con un error (si se marca como correcta, explicar el error).
-- RESPUESTA: al eliminar los dos elementos (en el drop 2 colectivos), la lista de colectivos queda vacía, por lo que al querer acceder al primer elemento de la lista (head), se produce un error.
-- III) La función nunca termina de evaluarse (si se marca como correcta, explicar por qué).
-}

-------------------------------------------------------------------- Pizza Conmigo ---------------------------------------------------------------------

-- 1) Modelado
-- a) Generar un data modelando la pizza.

data Pizza = Pizza{
    ingredientes :: [String],
    tamaño :: Number,
    cantidadDeCalorias :: Number
} deriving Show

-- El tamaño es una cantidad de porciones que va creciendo de a 2, a partir de 4. A modo de facilitar la lectura tenemos la siguiente escala:
-- 4 porciones = individual,
-- 6 = chica
-- 8 = grande
-- 10 = gigante

-- b) Crear la función constante grandeDeMuzza, que es una pizza que tiene “salsa”, “mozzarella” y “orégano”, tiene 8 porciones, y tiene 350 calorías.

grandeDeMuzza :: Pizza
grandeDeMuzza = Pizza ["salsa", "mozzarella", "orégano"] 8 350

-- 2) Calcular nivel de satisfacción que da una Pizza: 
-- a) 0 si tiene palmito
-- b) cantidad de ingredientes * 80, siempre y cuando tenga menos de 500 calorías, en caso contrario es la mitad del cálculo.
-- Nota: Evitar repetición de lógica

tienePalmito :: Pizza -> Bool
tienePalmito pizza = "palmito" `elem` ingredientes pizza

nivelDeSatisfaccion :: Pizza -> Number
nivelDeSatisfaccion pizza
    | tienePalmito pizza = 0
    | otherwise = min (cantidadDeIngredientes pizza * 80) (cantidadDeCalorias pizza / 2)

cantidadDeIngredientes :: Pizza -> Number
cantidadDeIngredientes pizza = length (ingredientes pizza)

-- 3) Calcular el valor de una pizza que es 120 veces la cantidad de ingredientes, multiplicado por su tamaño.

calcularValorPizza :: Pizza -> Number
calcularValorPizza pizza = 120 * cantidadDeIngredientes pizza * tamaño pizza

-- 4) Implementar las siguientes funciones:
-- a) nuevoIngrediente : Agrega un ingrediente a una pizza y agrega en calorías el doble de la cantidad de letras que tiene dicho ingrediente

nuevoIngrediente :: String -> Pizza -> Pizza
nuevoIngrediente ingrediente pizza = pizza {
    ingredientes = ingredientes pizza ++ [ingrediente],
    cantidadDeCalorias = cantidadDeCalorias pizza + 2 * length ingrediente
}

-- b) agrandar : agrega 2 porciones al tamaño. En el caso de ya tener el máximo de porciones, las mismas siguen siendo dicho máximo.

agrandar :: Pizza -> Pizza
agrandar pizza = pizza {
    tamaño = min 10 (tamaño pizza + 2)
}

-- c) mezcladita : es la combinación de 2 gustos de pizza, donde ocurre que la primera se le mezcla a la segunda, es decir, los ingredientes se le suman (sacando los repetidos) y de las calorías se le suma la mitad de la primera pizza a combinar. Por ejemplo, si mezclamos una pizza chica de provolone con jamón con una gigante napolitana, queda una gigante napolitana con provolone y jamón. (Sí, este punto se pensó con hambre).
-- Nota: No duplicar lógica

agregarSinRepetir :: Eq a => [a] -> [a] -> [a]
agregarSinRepetir base agregados =
    foldl agregar base agregados
    where
        agregar base agregado
            | agregado `notElem` base = agregado : base
            | otherwise = base

mezcladita :: Pizza -> Pizza -> Pizza
mezcladita pizza1 pizza2 = Pizza {
    ingredientes = agregarSinRepetir (ingredientes pizza1) (ingredientes pizza2),
    tamaño = tamaño pizza2,
    cantidadDeCalorias = cantidadDeCalorias pizza2 + (cantidadDeCalorias pizza1 / 2)
}

-- ¡Ahora tenemos pedidos! Entendemos un pedido como varias pizzas.

type Pedido = [Pizza]

type Pizzeria = Pedido -> Pedido

-- 5) Calcular el nivel de satisfacción de un pedido, que es la sumatoria de la satisfacción que brinda cada pizza que compone el mismo. Nota: Usar composición.

nivelDeSatisfaccionPedido :: Pedido -> Number
nivelDeSatisfaccionPedido = sum . map nivelDeSatisfaccion

-- 6) Cada pizzería es un mundo y, cuando hacemos un pedido y dependiendo de lo que queramos en el momento, optamos por una pizzería sobre otra. Aquí, vamos a modelar las pizzerías que conocemos:

-- a) pizzeriaLosHijosDePato : A cada pizza del pedido le agrega palmito. ¿Por qué?... No hay “por qué”... Sólo que son unos verdaderos hijos de Pato.

pizzeriaLosHijosDePato :: Pizza -> Pizza
pizzeriaLosHijosDePato = nuevoIngrediente "palmito"

-- b) pizzeriaElResumen : Dado un pedido, entrega las combinaciones de una pizza con la siguiente. Es decir, la primera con la segunda, la segunda con la tercera, etc. (y, por lo tanto, termina enviando un pedido que tiene una pizza menos que el pedido original, por el resultado de la combinación de pares de pizzas). Si el pedido tiene una sola pizza, no produce cambios. Nota: En esta definición puede usarse recursividad, aunque no es necesario. pro-tip: función zip o zipWith.

pizzeriaElResumen :: Pizzeria
pizzeriaElResumen pedido
    | length pedido == 1 = pedido
    | otherwise = zipWith mezcladita pedido $ tail pedido

-- c) pizzeriaEspecial : Una pizzería especial tiene un sabor predilecto de pizza y todas las pizzas del pedido las combina con esa.
    -- La pizzeriaPescadito es un caso particular de este, donde su sabor predilecto es de anchoas básica: tiene salsa, anchoas, sólo posee 270 calorías y es de 8 porciones.


pizzeriaEspecial :: Pizza -> Pizzeria
pizzeriaEspecial saborPredilecto = map (mezcladita saborPredilecto)


pizzeriaPescadito :: Pizzeria
pizzeriaPescadito = pizzeriaEspecial anchovasBasica

anchovasBasica :: Pizza
anchovasBasica = Pizza ["salsa", "anchoas"] 8 270

-- d) pizzeriaGourmet : Del pedido solo envía aquellas para las cuales el nivel de satisfacción supera el nivel de exquisitez de la pizzería... el resto no, las considera deplorables. Y, de regalo, a aquellas que manda las agranda a la siguiente escala, si esto es posible.
    -- La pizzeriaLaJauja, es un clásico caso gourmet con un parámetro de exquisitez de 399.

pizzeriaGourmet :: Number -> Pizzeria
pizzeriaGourmet nivelDeEsquisitez = filter (not . esDeplorable)
    where esDeplorable pizza = nivelDeSatisfaccion pizza < nivelDeEsquisitez

pizzeriaLaJauja :: Number -> Pizzeria
pizzeriaLaJauja 399 = pizzeriaGourmet 399

-- 7) Pizzerías & Pedidos
-- a) Implementar la función sonDignasDeCalleCorrientes que, dado un pedido y una lista de pizzerías, devuelve aquellas pizzerías que mejoran la satisfacción del pedido.

sonDignasDeCalleCorrientes :: Pedido -> [Pizzeria] -> [Pizzeria]
sonDignasDeCalleCorrientes pedido = filter (mejoraSatisfaccion pedido)
    where mejoraSatisfaccion pedido pizzeria = nivelDeSatisfaccionPedido (pizzeria pedido) > nivelDeSatisfaccionPedido pedido

-- b) Dado un pedido y una lista de pizzerías encontrar la pizzería que maximiza la satisfacción que otorga el pedido.

mayorSegun :: Ord a => (t -> a) -> t -> t -> t
mayorSegun f a b
    | f a > f b = a
    | otherwise = b

maximoSegun :: Ord a1 => (a2 -> a1) -> [a2] -> a2
maximoSegun f = foldl1 (mayorSegun f)

pizzeriaQueMAximisaLaSatisfaccion :: Pizzeria -> [Pizzeria -> Pedido] -> Pizzeria -> Pedido
pizzeriaQueMAximisaLaSatisfaccion pedido = maximoSegun (nivelDeSatisfaccionPedido . ($ pedido))

-- 8) Explicar el tipo de la siguiente función:
-- yoPidoCualquierPizza x y z = any (odd . x . fst) z && all (y . snd) z

-- RESPUESTA: z es una lista de tuplas, lista porque se usan any y all, y tupla (ya que usan snd y fst), x e y son funciones (ya que se usan en composicion con otras funciones)

-- 9) Bonus: Todos tenemos preferencias, y algunas veces nuestra preferencia es que se junten los mejores pizzeros y hagan lo que mejor saben. Implementar laPizzeriaPredilecta, que dada una lista de pizzerias, devuelve una pizzería teóricamente perfecta que haga los pedidos de todas juntas.

laPizzeriaPredilecta :: [c -> c] -> c -> c
laPizzeriaPredilecta = foldl1 (.)