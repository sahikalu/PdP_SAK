module Library where
import PdePreludat

{-
Pizza, comida tan noble si la hay, con sus distintas variedades, que suelen generar amigos, rivales y hasta enemigos acérrimos.
La pizza tiene ingredientes, tamaño, y la cantidad de calorías. El tamaño es una cantidad de porciones que va creciendo de a 2, a partir de 4. A modo de facilitar la lectura tenemos la siguiente escala:
4 porciones = individual,
6 = chica
8 = grande
10 = gigante

Nota: Resolver maximizando el uso de: composición, aplicación parcial y orden superior. No usar recursividad a menos que se indique lo contrario.
Se pide:

-}

-- 1) Modelado
-- a) Generar un data modelando la pizza.

data Pizza = Pizza {
    ingredientes :: [String],
    tamanio :: Number,
    cantidadDeCalorias :: Number
} deriving Show

-- b) Crear la función constante grandeDeMuzza, que es una pizza que tiene “salsa”, “mozzarella” y “orégano”, tiene 8 porciones, y tiene 350 calorías.

grandeDeMuzza :: Pizza
grandeDeMuzza = Pizza {ingredientes = ["Salsa", "Muzzarella", "orégano"], tamanio = 8, cantidadDeCalorias = 350}

-- 2) Calcular nivel de satisfacción que da una Pizza:
-- a) 0 si tiene palmito
-- b) cantidad de ingredientes * 80, siempre y cuando tenga menos de 500 calorías, en caso contrario es la mitad del cálculo.
-- Nota: Evitar repetición de lógica

nivelDeSatisfaccion :: Pizza -> Number
nivelDeSatisfaccion (Pizza ings _ cal)
    | "palmitos" `elem` ings = 0
    | cal < 500 = valorCalorias
    | otherwise = valorCalorias / 2
        where valorCalorias = length ings * 80

-- 3) Calcular el valor de una pizza que es 120 veces la cantidad de ingredientes, multiplicado por su tamaño.

valorDeUnaPizza :: Pizza -> Number
valorDeUnaPizza (Pizza ings tam _) = tam * 120 * length ings

-- 4) Implementar las siguientes funciones:

-- a) nuevoIngrediente : Agrega un ingrediente a una pizza y agrega en calorías el doble de la cantidad de letras que tiene dicho ingrediente

agregarSinRepetir :: Eq String => [String] -> [String] -> [String]
agregarSinRepetir listaBase agregados = foldl agregar listaBase agregados
    where agregar listaBase elemento
            | elemento `notElem` listaBase = elemento : listaBase
            | otherwise = listaBase

nuevoIngrediente :: String -> Pizza -> Pizza
nuevoIngrediente ingrediente pizza
    | ingrediente `elem` ingredientes pizza = pizza
    | otherwise = pizza {
                    ingredientes = agregarSinRepetir (ingredientes pizza) [ingrediente],
                    cantidadDeCalorias = cantidadDeCalorias pizza + 2 * length ingrediente
                    }

-- b) agrandar : agrega 2 porciones al tamaño. En el caso de ya tener el máximo de porciones, las mismas siguen siendo dicho máximo.

agrandar :: Pizza -> Pizza
agrandar pizza = pizza {tamanio = min 10 $ tamanio pizza + 2}

-- c) mezcladita : es la combinación de 2 gustos de pizza, donde ocurre que la primera se le mezcla a la segunda, es decir, los ingredientes se le suman (sacando los repetidos) y de las calorías se le suma la mitad de la primera pizza a combinar. Por ejemplo, si mezclamos una pizza chica de provolone con jamón con una gigante napolitana, queda una gigante napolitana con provolone y jamón. (Sí, este punto se pensó con hambre).
-- Nota: No duplicar lógica

mezclaDeIngredientes :: Pizza -> Pizza -> [String]
mezclaDeIngredientes pizza1 pizza2 = agregarSinRepetir (ingredientes pizza1) (ingredientes pizza2)

calculoCalorias :: Pizza -> Pizza -> Number
calculoCalorias  pizza1 pizza2 = ((/2) . cantidadDeCalorias) pizza1 + cantidadDeCalorias pizza2

mezcladita :: Pizza -> Pizza -> Pizza
mezcladita pizza1 pizza2 = pizza2 {
    ingredientes = mezclaDeIngredientes pizza1 pizza2,
    cantidadDeCalorias = calculoCalorias pizza1 pizza2
}

-- 5) Calcular el nivel de satisfacción de un pedido, que es la sumatoria de la satisfacción que brinda cada pizza que compone el mismo. Nota: Usar composición.
type Pedido = [Pizza]

niveldDeSatisfaccionPedido :: Pedido -> Number
niveldDeSatisfaccionPedido = sum . map nivelDeSatisfaccion

-- 6) Cada pizzería es un mundo y, cuando hacemos un pedido y dependiendo de lo que queramos en el momento, optamos por una pizzería sobre otra. Aquí, vamos a modelar las pizzerías que conocemos:

-- a) pizzeriaLosHijosDePato : A cada pizza del pedido le agrega palmito. ¿Por qué?... No hay “por qué”... Sólo que son unos verdaderos hijos de Pato.

type Pizzeria = Pedido -> Pedido

pizzeriaLosHijosDePato :: Pedido -> Pedido
pizzeriaLosHijosDePato = map (nuevoIngrediente "palmitos")

-- b) pizzeriaElResumen : Dado un pedido, entrega las combinaciones de una pizza con la siguiente. Es decir, la primera con la segunda, la segunda con la tercera, etc. (y, por lo tanto, termina enviando un pedido que tiene una pizza menos que el pedido original, por el resultado de la combinación de pares de pizzas). Si el pedido tiene una sola pizza, no produce cambios. 
-- Nota: En esta definición puede usarse recursividad, aunque no es necesario. pro-tip: función zip o zipWith.

pizzeriaElResumen :: Pedido -> Pedido
pizzeriaElResumen [pizza] = [pizza]
pizzeriaElResumen pedido = zipWith mezcladita pedido $ tail pedido

-- c) pizzeriaEspecial : Una pizzería especial tiene un sabor predilecto de pizza y todas las pizzas del pedido las combina con esa.
-- La pizzeriaPescadito es un caso particular de este, donde su sabor predilecto es de anchoas básica: tiene salsa, anchoas, sólo posee 270 calorías y es de 8 porciones.

pizzeriaEspecial :: Pizza -> Pizzeria
pizzeriaEspecial predilecta = map (mezcladita predilecta)

pizzaDeAnchoasBasica :: Pizza
pizzaDeAnchoasBasica = Pizza {
    ingredientes = ["Salsa","Anchoas"],
    tamanio = 8,
    cantidadDeCalorias = 270
}

pizzaPescadito :: Pedido -> Pedido
pizzaPescadito = pizzeriaEspecial pizzaDeAnchoasBasica

-- d) pizzeriaGourmet : Del pedido solo envía aquellas para las cuales el nivel de satisfacción supera el nivel de exquisitez de la pizzería... el resto no, las considera deplorables. Y, de regalo, a aquellas que manda las agranda a la siguiente escala, si esto es posible.
-- La pizzeriaLaJauja, es un clásico caso gourmet con un parámetro de exquisitez de 399.

pizzeriaGourmet :: Number -> Pizzeria
pizzeriaGourmet nvelDeEsquisitez = map agrandar . filter (not . deplorable)
    where deplorable pizza = nivelDeSatisfaccion pizza < nvelDeEsquisitez


pizzeriaLaJauja :: Pizzeria
pizzeriaLaJauja = pizzeriaGourmet 399

-- 7) Pizzerías & Pedidos
-- a) Implementar la función sonDignasDeCalleCorrientes que, dado un pedido y una lista de pizzerías, devuelve aquellas pizzerías que mejoran la satisfacción del pedido.


sonDignasDeCalleCorrientes :: Pedido -> [Pizzeria] -> [Pizzeria]
sonDignasDeCalleCorrientes pedido pizzeria = filter (mejoraSatisfaccion pedido) pizzeria
    where mejoraSatisfaccion pedido pizzeria = niveldDeSatisfaccionPedido pedido < niveldDeSatisfaccionPedido (pizzeria pedido)

-- b) Dado un pedido y una lista de pizzerías encontrar la pizzería que maximiza la satisfacción que otorga el pedido.

maximoSegun :: Ord a1 => (a2 -> a1) -> [a2] -> a2
maximoSegun f = foldl1 (mayorSegun f)

mayorSegun :: Ord a => (t -> a) -> t -> t -> t
mayorSegun f a b
    | f a > f b = a
    | otherwise = b


mejorPizzeria :: p -> [p -> Pedido] -> p -> Pedido
mejorPizzeria pedido = maximoSegun (niveldDeSatisfaccionPedido . ($ pedido))

-- 8) Explicar el tipo de la siguiente función:
{-
    yoPidoCualquierPizza x y z = any (odd . x . fst) z && all (y . snd) z

    x e y prticipan en una composicion, por lo que son funciones

    z es una lista de tuplas (por que se usa fst y snd ) , de dos elementos (a,b)
-}

-- 9) bonus:Todos tenemos preferencias, y algunas veces nuestra preferencia es que se junten los mejores pizzeros y hagan lo que mejor saben. Implementar laPizzeriaPredilecta, que dada una lista de pizzerias, devuelve una pizzería teóricamente perfecta que haga los pedidos de todas juntas.

laPizzeriaPredilecta :: [Pizzeria] -> Pizzeria
laPizzeriaPredilecta = foldl1 (.)