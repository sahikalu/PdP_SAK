module Library where
import PdePreludat

----------------------------------------------------------- ENTREGA 1 -----------------------------------------------------------

-- Personas
bombon :: Persona
bombon = Persona { nombreChica = "Bombon" , nivelResistencia = 55, habilidades = ["escuchar canciones de Luciano Pereyra", "dar golpes fuertes"], amigos = ["seniorCerdo", "silico"]}
burbuja :: Persona
burbuja = Persona { nombreChica = "Burbuja" , nivelResistencia = 30, habilidades = ["velocidad", "lanzar burbujas"], amigos = ["senioritaBelo"]}
bellota :: Persona
bellota = Persona { nombreChica = "Bellota" , nivelResistencia = 75, habilidades = ["velocidad", "superfuerza"], amigos = []}
senioritaBelo :: Persona
senioritaBelo = Persona { nombreChica = "Señorita Belo" , nivelResistencia = 10, habilidades = ["no mostrar la cara"], amigos = ["burbuja"]}
seniorCerdo :: Persona
seniorCerdo = Persona { nombreChica = "Señor Cerdo" , nivelResistencia = 0, habilidades = [], amigos = ["bellota"]}
silico :: Persona
silico = Persona { nombreChica = "Silico" , nivelResistencia = 29, habilidades = ["tolerar los numeros impares"], amigos = ["bombon", "burbuja"]}

-- Amenazas
mojoJojo :: Amenaza
mojoJojo = Amenaza {nombreAmenaza = "Mojo Jojo", proposito = ["destruir a las Chicas Superpoderosas"], nivelPoder = 70, debilidades = ["velocidad", "superfuerza"]}
princesa :: Amenaza
princesa = Amenaza {nombreAmenaza = "Princesa", proposito = ["ser la unica Chica Superpoderosas"], nivelPoder = 95, debilidades = ["burbujas", "golpes fuertes"]}
bandaGangrena :: Amenaza
bandaGangrena = Amenaza {nombreAmenaza = "Banda Gangrena", proposito = ["esparcir el caos", "hacer que todos sean flojos y peleen entre ellos"], nivelPoder = 49, debilidades = ["escuchar canciones de Luciano Pereyra", "superfuerza", "kryptonita"]}

listaAmenazas :: [Amenaza]
listaAmenazas = [mojoJojo, princesa,bandaGangrena]

data Persona = Persona {
    nombreChica :: String,
    nivelResistencia :: Number,
    habilidades :: [String],
    amigos :: [String]
} deriving (Show, Eq)

data Amenaza = Amenaza {
    nombreAmenaza:: String,
    proposito :: [String],
    nivelPoder :: Number,
    debilidades :: [String]
} deriving Show

data Ciudad = Ciudad {
    nombreCiudad :: String,
    cantidadHabitantes :: Number
} deriving Show

-- Calcular el daño potencial de una amenaza, el cual se calcula como el nivel de poder, menos el triple de su cantidad de debilidades.

danioPotencial :: Amenaza -> Number
danioPotencial amenaza = nivelPoder amenaza - ((3*).length.debilidades) amenaza

-- Modelar todo lo necesario para saber si una amenaza puede atacar una ciudad. Si una amenaza tiene un daño potencial mayor al doble del número de habitantes de la ciudad, entonces puede atacar a la ciudad.

puedeAtacarCiudad :: Amenaza -> Ciudad -> Bool
puedeAtacarCiudad amenaza = (danioPotencial amenaza >).((2*). cantidadHabitantes)

-- Saber si una chica puede vencer a una amenaza. Si tiene longitud de propósito par, ocurre si la resistencia es mayor a la mitad del daño potencial de una amenaza. Si el propósito tiene longitud impar entonces, es suficiente que la resistencia sea mayor al daño potencial.

chicaVenceAmenaza :: Persona -> Amenaza -> Bool
chicaVenceAmenaza chica amenaza
    | (even.length.proposito) amenaza = nivelResistencia chica > ((1/2*).danioPotencial) amenaza
    | otherwise = nivelResistencia chica > danioPotencial amenaza

-- Determinar si una amenaza es de nivel alto, lo que ocurre si tiene una cantidad par de debilidades, las mismas no incluyen kryptonita y su daño potencial es mayor a 50.

debilidadConKryptonita :: Amenaza -> Bool
debilidadConKryptonita = ("kryptonita" `elem`).debilidades

cantidadParDebilidades :: Amenaza -> Bool
cantidadParDebilidades  = even.length.debilidades

mayorA50 :: Amenaza -> Bool
mayorA50 = (50<).danioPotencial

nivelAmenazaAlto :: Amenaza -> Bool
nivelAmenazaAlto amenaza = not (debilidadConKryptonita amenaza) && cantidadParDebilidades amenaza && mayorA50 amenaza

----------------------------------------------------------- ENTREGA 2 -----------------------------------------------------------

elementoPerteneceALista :: (Eq a) => t -> (t -> [a]) -> a -> Bool
elementoPerteneceALista persona algo elemento = elemento `elem` algo persona

------------------------------------------------ ENTRADA EN CALOR (individual) ------------------------------------------------

-- 1) Determinar si una amenaza es invulnerable para una chica, lo cual ocurre si la chica no tiene habilidades que sean debilidad de la amenaza

esInvulnerable :: Persona -> Amenaza -> Bool
esInvulnerable chica = not . any (elementoPerteneceALista chica habilidades) . debilidades

-- 2) Dada una lista de amenazas, determinar cuál es la amenaza preponderante, que es aquella que tenga más nivel de poder.
    {-- Se reajusta la definición de la estructura Amenazas: agregado de dato nombreAmenaza (no requerido en la primer entrega). 
    Cambios en estructura Persona: nombre se reemplaza por nombreChica. No se descartan futuras modificaciones en torno a unificación del dato nombre (sujeto a detección de necesidad).-}

mayorNivelDePoder :: Amenaza -> Amenaza -> Amenaza
mayorNivelDePoder amenaza1 amenaza2
    | nivelPoder amenaza1 > nivelPoder amenaza2     = amenaza1
    | otherwise                                     = amenaza2

-- Usando foldl1, point-free mediante
maximoPoder :: [Amenaza] -> String
maximoPoder = nombreAmenaza.foldl1 mayorNivelDePoder

-- Otra posible opción utilizando recursividad y pattern matching
--maximoPoder' :: [Amenaza] -> String
--maximoPoder' [] = [] 
--maximoPoder' [x] = nombreAmenaza x 
--maximoPoder' (amenaza1:amenaza2:amenazas) = maximoPoder(mayorNivelDePoder amenaza1 amenaza2:amenazas)
-- Acotación: es interesante que la imagen de la función responda solo a la imagen de la función con parámetro [x], que es la que en definitiva nos interesa dado que muestra a la amenaza preponderante. Mientras se tenga un listado mayor de amenazas, la función devuelve el dato completo amenaza.

-- 3) Dada una lista de chicas y una amenaza, determinar los nombres de aquellas que pueden vencer la amenaza.

chicasVencenAmenaza :: [Persona] -> Amenaza -> [String]
chicasVencenAmenaza [] amenaza = []
chicasVencenAmenaza (chica:chicas) amenaza
    |chicaVenceAmenaza chica amenaza = nombreChica chica: chicasVencenAmenaza chicas amenaza
    |otherwise = chicasVencenAmenaza chicas amenaza

-- 4) En base a una lista de chicas, saber cuáles tienen nombre que empieza con B y más de una habilidad.

nombreEmpiezaConB :: Persona -> Bool
nombreEmpiezaConB = (== 'B') . head . nombreChica

masDeUnaHabilidad :: Persona -> Bool
masDeUnaHabilidad = (> 1) . length . habilidades

chicasConNombreBYMasDeUnaHabilidad :: [Persona] -> [String]
chicasConNombreBYMasDeUnaHabilidad = map nombreChica . filter cumpleConLosRequisitos
    where cumpleConLosRequisitos chica =  nombreEmpiezaConB chica && masDeUnaHabilidad chica

------------------------------------------------ YENDO AL NUTRICIONISTA (individual) ------------------------------------------------

-- Cuando una Chica Superpoderosa consume ciertos alimentos o bebidas (los vamos a llamar alimentos en general), suele verse afectada de diferentes formas:

type Alimento = Persona -> Persona

-- 1) a) La sustancia X la deja sin resistencia.
sustanciaX :: Alimento
sustanciaX chica = chica {nivelResistencia = 0}

mostrarResultadoSustanciaX :: Persona -> Number
mostrarResultadoSustanciaX chica = nivelResistencia (sustanciaX chica)

-- 1) b) La cerveza siempre se toma con amigos, aunque sean potenciales, así para esta bebida se conoce las personas con las que se está tomando, y las que no sean amigas, se agregan como tales.

cervezaConAmigos :: Persona -> [String] -> Number
cervezaConAmigos tomador amigoDelTomador = length (amigos (agregarAmigo tomador amigoDelTomador))

agregarAmigo :: Persona -> [String] -> Persona
agregarAmigo tomador [] = tomador
agregarAmigo tomador (amigoDelTomador:amigosDelTomador)
    | amigoDelTomador `notElem` amigos tomador = agregarAmigo tomadorMasNuevoAmigo amigosDelTomador
    | amigoDelTomador `elem` amigos tomador = agregarAmigo tomador amigosDelTomador
        where   tomadorMasNuevoAmigo = tomador { amigos = amigos tomador ++ [amigoDelTomador] }


-- 2) a) El saborizador tiene diferentes gustos, como "Fresa", "Arándano" y "Cereza", entre otros. Un saborizador reduce la resistencia de la Chica que lo consume tanto como la cantidad de letras que tenga el sabor. Por ejemplo, si alguien toma saborizador de Fresa, su resistencia se reduciría en 5 unidades.

type Saborizador = String

saborizantes :: [Saborizador]
saborizantes = ["Uva", "Anis", "Fresa", "Cereza", "Naranja", "Arandano", "Cacahuate"]
-- se agregan algunos saborizantes adicionales a los requeridos

consumeSaborizante :: Persona -> Saborizador -> Persona
consumeSaborizante chica saborizante = chica {nivelResistencia = nuevoNivel}
    where nuevoNivel = nivelResistencia chica - length saborizante

-- Opción alternativa con resultado centrado únicamente en lo que interesa: nuevo nivel de resistencia.
{-
consumeSaborizante' :: Persona -> Saborizador -> [Char]
consumeSaborizante' chica saborizante = "Nuevo nivel de poder: " ++ show nuevoNivel 
    where nuevoNivel = nivelResistencia chica - length saborizante
-}

-- 2) b) El querido ferne’, donde al consumirlo obtiene automáticamente la habilidad de “Chef de Asados”. Si ya la tiene, no se agrega.

-- En vez de mostrarse la estructura de datos actualizada para la chica superpoderosa, esta opción se enfoca únicamente en las habilidades resultantes del consumo del ferne'. La validación de testeo en Spec también se facilita, dado que solo se centra en la lista de habilidades.

consumeFernet :: Persona -> [String]
consumeFernet chica = nuevaHabilidad
    where nuevaHabilidad
            | (("Chef de Asados" `notElem`).habilidades) chica     = habilidades chica ++ ["Chef de Asados"]
            | otherwise                                            = habilidades chica

{- Opción alternativa: muestra la estructura de datos completos de la consumidora de fernet. Se deja en segundo plano por no ser una salida clara para la evaluación del testeo.

consumeFernet':: Persona -> Persona
consumeFernet' chica = chica { habilidades = nuevaHabilidad}
    where nuevaHabilidad
            | "Chef de Asados" `notElem` habilidades chica         = habilidades chica ++ ["Chef de Asados"]
            | otherwise                                            = habilidades chica
-}

-- 3)
-- a_El Gatorei, cuyo consumo está recomendado por el doctor Bilardo, es una bebida que recupera 5 puntos de resistencia a la Chica que lo consume por cada amiga que tenga.
-- El vodka afecta seriamente a una Chica Superpoderosa, haciendo que cambie su nombre perdiendo la última letra del mismo por cada shot que tome.


consumeGatorei :: Persona -> Number
consumeGatorei chica = nivelResistencia chica + ((5*) . length . amigos) chica

--b_ El vodka afecta seriamente a una Chica Superpoderosa, haciendo que cambie su nombre perdiendo la última letra del mismo por cada shot que tome. 


consumeVodka :: Persona -> Number -> [Char]
consumeVodka chica cantidadShots
    |cantidadShots < length nombre = take (length nombre- cantidadShots) nombre
    |otherwise = ""
        where nombre = nombreChica chica

-- 4)
-- a_ El caramelo líquido reduce 10 unidades de resistencia a la Chica que lo consume.

consumeCarameloLiquido :: Persona -> Number
consumeCarameloLiquido =  (-10 +)  . nivelResistencia

-- b_ La cocucha (que sabemos que saca hasta el óxido), le elimina la primera habilidad a quien la ingiera. Si no tiene habilidades, no causa ningún efecto.

consumeCocucha :: Persona -> [String]
consumeCocucha  chica
    |not (null (habilidades chica)) = ( tail .habilidades ) chica
    |otherwise = []
