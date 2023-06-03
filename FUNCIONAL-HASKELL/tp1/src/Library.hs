module Library where
import PdePreludat
import Control.Concurrent (Chan)
import Data.Char (toUpper)
----------------------------------------------------------------- ENTREGA 1 -----------------------------------------------------------------

-- Personas
bombon :: Persona
bombon = Persona { nombreChica = "Bombon" , nivelResistencia = 55, habilidades = ["escuchar canciones de Luciano Pereyra", "golpes fuertes"], amigos = ["seniorCerdo", "silico"] }
burbuja :: Persona
burbuja = Persona { nombreChica = "Burbuja" , nivelResistencia = 30, habilidades = ["velocidad", "burbujas"], amigos = ["senioritaBelo"] }
bellota :: Persona
bellota = Persona { nombreChica = "Bellota" , nivelResistencia = 75, habilidades = ["velocidad", "superfuerza"], amigos = [] }
senioritaBelo :: Persona
senioritaBelo = Persona { nombreChica = "Señorita Belo" , nivelResistencia = 10, habilidades = ["no mostrar la cara"], amigos = ["burbuja"] }
seniorCerdo :: Persona
seniorCerdo = Persona { nombreChica = "Señor Cerdo" , nivelResistencia = 0, habilidades = [], amigos = ["bellota"] }
silico :: Persona
silico = Persona { nombreChica = "Silico" , nivelResistencia = 29, habilidades = ["tolerar los numeros impares"], amigos = ["bombon", "burbuja"] }

-- Amenazas
mojoJojo :: Amenaza
mojoJojo = Amenaza {nombreAmenaza = "Mojo Jojo", proposito = ["destruir a las Chicas Superpoderosas"], nivelPoder = 70, debilidades = ["velocidad", "superfuerza"], efecto = rumorDeDobleHuida }
princesa :: Amenaza
princesa = Amenaza {nombreAmenaza = "Princesa", proposito = ["ser la unica Chica Superpoderosas"], nivelPoder = 95, debilidades = ["burbujas", "golpes fuertes"], efecto = sinEfecto }
bandaGangrena :: Amenaza
bandaGangrena = Amenaza {nombreAmenaza = "Banda Gangrena", proposito = ["esparcir el caos", "hacer que todos sean flojos y peleen entre ellos"], nivelPoder = 49, debilidades = ["escuchar canciones de Luciano Pereyra", "superfuerza", "kryptonita"], efecto = cambiaNombreCiudadDuplicaHabitantes }

listaAmenazas :: [Amenaza]
listaAmenazas = [mojoJojo, princesa, bandaGangrena]

-- Ciudad
saltadilla :: Ciudad
saltadilla = Ciudad { nombreCiudad = "Saltadilla", cantidadHabitantes = 21 }
seul :: Ciudad
seul = Ciudad { nombreCiudad = "Seul", cantidadHabitantes = 100 }
losAngeles :: Ciudad
losAngeles = Ciudad { nombreCiudad = "Los Angeles", cantidadHabitantes = 20 }
londres :: Ciudad
londres = Ciudad { nombreCiudad = "Londres", cantidadHabitantes = 50 }
laFerrere :: Ciudad
laFerrere = Ciudad { nombreCiudad = "La Ferrere", cantidadHabitantes = 3000 } -- cuando toca La Renga
laMatanza :: Ciudad
laMatanza = Ciudad { nombreCiudad = "La Matanza", cantidadHabitantes = 45 }

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
    debilidades :: [String],
    efecto :: Efecto
} deriving Show

type Efecto = Ciudad -> Ciudad

data Ciudad = Ciudad {
    nombreCiudad :: String,
    cantidadHabitantes :: Number
} deriving (Show, Eq)

data Capitulo = Capitulo {
    amenaza :: Amenaza,
    nombreCiudadCapitulo :: String,
    chica :: Persona,
    alimentos :: [Alimento],
    numeroAtaques :: Number
} deriving Show

-- Calcular el daño potencial de una amenaza, el cual se calcula como el nivel de poder, menos el triple de su cantidad de debilidades.

danioPotencial :: Amenaza -> Number
danioPotencial amenaza = nivelPoder amenaza - ((3 * ) . length.debilidades) amenaza

-- Modelar todo lo necesario para saber si una amenaza puede atacar una ciudad. Si una amenaza tiene un daño potencial mayor al doble del número de habitantes de la ciudad, entonces puede atacar a la ciudad.

puedeAtacarCiudad :: Amenaza -> Ciudad -> Bool
puedeAtacarCiudad amenaza = (danioPotencial amenaza >) . ((2 * ) . cantidadHabitantes)

-- Saber si una chica puede vencer a una amenaza. Si tiene longitud de propósito par, ocurre si la resistencia es mayor a la mitad del daño potencial de una amenaza. Si el propósito tiene longitud impar entonces, es suficiente que la resistencia sea mayor al daño potencial.

chicaVenceAmenaza :: Persona -> Amenaza -> Bool
chicaVenceAmenaza chica amenaza
    | (even.length.proposito) amenaza = nivelResistencia chica > ((1 / 2 *) . danioPotencial) amenaza
    | otherwise                       = nivelResistencia chica > danioPotencial amenaza

-- Determinar si una amenaza es de nivel alto, lo que ocurre si tiene una cantidad par de debilidades, las mismas no incluyen kryptonita y su daño potencial es mayor a 50.

debilidadConKryptonita :: Amenaza -> Bool
debilidadConKryptonita = ("kryptonita" `elem`) . debilidades

cantidadParDebilidades :: Amenaza -> Bool
cantidadParDebilidades  = even . length . debilidades

mayorA50 :: Amenaza -> Bool
mayorA50 = (50 < ) . danioPotencial

nivelAmenazaAlto :: Amenaza -> Bool
nivelAmenazaAlto amenaza = not (debilidadConKryptonita amenaza) && cantidadParDebilidades amenaza && mayorA50 amenaza

----------------------------------------------------------------- ENTREGA 2 -----------------------------------------------------------------

elementoPerteneceALista :: (Eq a) => t -> (t -> [a]) -> a -> Bool
elementoPerteneceALista persona algo elemento = elemento `elem` algo persona

----------------------------------------------------------- ENTRADA EN CALOR (individual) -----------------------------------------------------------

-- 1) Determinar si una amenaza es invulnerable para una chica, lo cual ocurre si la chica no tiene habilidades que sean debilidad de la amenaza

amenazaEsInvulnerable :: Persona -> Amenaza -> Bool
amenazaEsInvulnerable chica = not . any (elementoPerteneceALista chica habilidades) . debilidades

-- 2) Dada una lista de amenazas, determinar cuál es la amenaza preponderante, que es aquella que tenga más nivel de poder.
    {-- Se reajusta la definición de la estructura Amenazas: agregado de dato nombreAmenaza (no requerido en la primer entrega). 
    Cambios en estructura Persona: nombre se reemplaza por nombreChica. No se descartan futuras modificaciones en torno a unificación del dato nombre (sujeto a detección de necesidad).-}

mayorSegun :: Ord a => (p -> a) -> p -> p -> p
mayorSegun f a b
    | f a > f b      = a
    | otherwise      = b

mayorNivelDePoder :: Amenaza -> Amenaza -> Amenaza
mayorNivelDePoder = mayorSegun nivelPoder

-- Usando foldl1, point-free mediante
maximoPoder :: [Amenaza] -> Amenaza
maximoPoder = foldl1 mayorNivelDePoder

-- 3) Dada una lista de chicas y una amenaza, determinar los nombres de aquellas que pueden vencer la amenaza.

listaChicas :: [Persona]
listaChicas = [bombon, burbuja, bellota]

--me gusta más:
chicasVencenAmenaza :: [Persona] -> Amenaza -> [String]
chicasVencenAmenaza listachicas amenaza = map nombreChica listaDeVencedoras
    where listaDeVencedoras = filter ((True==).(flip chicaVenceAmenaza amenaza)) listachicas

--chicasVencenAmenaza' :: Amenaza -> [Persona] -> [String]
--chicasVencenAmenaza' amenaza listachicas = map fst (filter ((True==).snd) (zip listaNombresChicas listaBooleanaVencedoras))
--    where listaNombresChicas = map nombreChica listachicas
--          listaBooleanaVencedoras = map (flip chicaVenceAmenaza amenaza) listachicas

-- 4) En base a una lista de chicas, saber cuáles tienen nombre que empieza con B y más de una habilidad.

{-nombreEmpiezaConB :: Persona -> Bool
nombreEmpiezaConB = (== 'B') . head . nombreChica -}

nombreEmpiezaCon :: [Char] -> Char -> Bool
nombreEmpiezaCon nombre letra = head nombre == toUpper letra

nombreEmpiezaConB :: Persona -> Bool
nombreEmpiezaConB chica = nombreEmpiezaCon (nombreChica chica) 'B'


masDeUnaHabilidad :: Persona -> Bool
masDeUnaHabilidad = (> 1) . length . habilidades

chicasConNombreBYMasDeUnaHabilidad :: [Persona] -> [String]
chicasConNombreBYMasDeUnaHabilidad     = map nombreChica . filter cumpleConLosRequisitos
    where cumpleConLosRequisitos chica = nombreEmpiezaConB chica && masDeUnaHabilidad chica

-------------------------------------------------------- YENDO AL NUTRICIONISTA (individual) --------------------------------------------------------

-- Cuando una Chica Superpoderosa consume ciertos alimentos o bebidas (los vamos a llamar alimentos en general), suele verse afectada de diferentes formas:

type Alimento = Persona -> Persona

-- 1) a) La sustancia X la deja sin resistencia.

cambiarNivelDeResistencia :: Number -> Alimento
cambiarNivelDeResistencia nuevoNivel chica = chica {nivelResistencia = nuevoNivel}

sustanciaX :: Alimento
sustanciaX = cambiarNivelDeResistencia 0

-- 1) b) La cerveza siempre se toma con amigos, aunque sean potenciales, así para esta bebida se conoce las personas con las que se está tomando, y las que no sean amigas, se agregan como tales.

cerveza :: [String] -> Alimento
cerveza [] chica                        = chica
cerveza (companieroDeBebida:companierosDeBebida) chica
    | companieroDeBebida `notElem` amigos chica = cerveza companierosDeBebida chicaConMasAmigos
    | otherwise    = cerveza companierosDeBebida  chica
        where   chicaConMasAmigos           = chica { amigos = amigos chica ++ [companieroDeBebida] }

-- 2) a) El saborizador tiene diferentes gustos, como "Fresa", "Arándano" y "Cereza", entre otros. Un saborizador reduce la resistencia de la Chica que lo consume tanto como la cantidad de letras que tenga el sabor. Por ejemplo, si alguien toma saborizador de Fresa, su resistencia se reduciría en 5 unidades.

type Saborizador = String

saborizantes :: [Saborizador]
saborizantes = ["Uva", "Anis", "Fresa", "Cereza", "Naranja", "Arandano", "Cacahuate"]
-- se agregan algunos saborizantes adicionales a los requeridos

saborizante :: Saborizador -> Alimento
saborizante sabor chica = cambiarNivelDeResistencia nuevoNivel chica
    where nuevoNivel = nivelResistencia chica - length sabor

-- 2) b) El querido ferne’, donde al consumirlo obtiene automáticamente la habilidad de “Chef de Asados”. Si ya la tiene, no se agrega.

-- En vez de mostrarse la estructura de datos actualizada para la chica superpoderosa, esta opción se enfoca únicamente en las habilidades resultantes del consumo del ferne'. La validación de testeo en Spec también se facilita, dado que solo se centra en la lista de habilidades.

fernet :: Alimento
fernet chica
    | (("Chef de Asados" `notElem`).habilidades) chica     = chica { habilidades = habilidades chica ++ ["Chef de Asados"]}
    | otherwise                                            = chica

-- 3)
-- a_El Gatorei, cuyo consumo está recomendado por el doctor Bilardo, es una bebida que recupera 5 puntos de resistencia a la Chica que lo consume por cada amiga que tenga.

gatorei :: Alimento
gatorei chica = cambiarNivelDeResistencia nuevoNivel chica
    where nuevoNivel = nivelResistencia chica + ((5 * ) . length . amigos) chica

--b_ El vodka afecta seriamente a una Chica Superpoderosa, haciendo que cambie su nombre perdiendo la última letra del mismo por cada shot que tome. 

vodka :: Number -> Alimento
vodka cantidadShots chica = chica {nombreChica = (reverse . (drop cantidadShots) . reverse ) (nombreChica chica) }
 

-- 4)
-- a_ El caramelo líquido reduce 10 unidades de resistencia a la Chica que lo consume.

carameloLiquido :: Alimento
carameloLiquido chica =  cambiarNivelDeResistencia nuevoNivel chica
    where nuevoNivel = nivelResistencia chica - 10

-- b_ La cocucha (que sabemos que saca hasta el óxido), le elimina la primera habilidad a quien la ingiera. Si no tiene habilidades, no causa ningún efecto.

cocucha :: Alimento
cocucha  chica
    | not (null (habilidades chica)) = chica { habilidades = ( tail .habilidades ) chica }
    | otherwise                      = chica

-------------------------------------------------------- MI VILLANO FAVORITO (grupal) --------------------------------------------------------

{-
Queremos representar el efecto que tiene un villano al atacar una ciudad. Cuando un villano intenta atacar una ciudad, pueda o no y sólo por motivos del rumor, su población escapa según una cantidad igual a la décima parte de su daño potencial (división entera). Además, si el villano efectivamente puede atacar la misma antes de esta fuga, luego de la misma se aplica un efecto adicional que depende del villano. Antes no lo sabíamos, pero los villanos pueden tener distintos efectos:

    Mojo Jojo hace correr el rumor de un segundo ataque, ya que asume que las Chicas Superpoderosas van a acudir más rápidamente y su objetivo es destruirlas, por lo que se fuga el doble de población.
    Princesa no hace nada, ya que su objetivo es ser la única Chica Superpoderosa y no le interesa tanto afectar a la ciudad.
    Banda Gangrena cambia el nombre de la ciudad por “Gangrena City” y duplica a la población, ya que clona a todos los habitantes para que todo sea más caótico.

En ninguno de los casos la población puede quedar negativa, a lo sumo la ciudad quedará desierta (con población de 0).

Banda Gangrena ataca Saltadilla dos veces consecutivas.
-}

rumorDeAtaque :: Amenaza -> Efecto
rumorDeAtaque amenaza ciudad = ciudad {cantidadHabitantes = max 0 (cantidadHabitantes ciudad - fugitivosRumores)}
    where fugitivosRumores =  div (danioPotencial amenaza) 10

rumorDeDobleHuida :: Efecto
rumorDeDobleHuida = rumorDeAtaque mojoJojo

sinEfecto :: Efecto
sinEfecto = id

cambiaNombreCiudadDuplicaHabitantes :: Efecto
cambiaNombreCiudadDuplicaHabitantes ciudad = ciudad {nombreCiudad = "Gangrena City", cantidadHabitantes = ((2 *) . cantidadHabitantes) ciudad}

ataqueCiudad :: Amenaza -> Efecto
ataqueCiudad amenaza ciudad
    | (not.puedeAtacarCiudad amenaza) ciudad                = soloRumor
    | otherwise                                             = calculoImpactoCiudad
        where soloRumor = rumorDeAtaque amenaza ciudad
              calculoImpactoCiudad = aplicarFuncionAIzquierda ciudad [efecto amenaza, rumorDeAtaque amenaza]

aplicarFuncionAIzquierda :: b -> [b -> b] -> b
aplicarFuncionAIzquierda = foldr ($)

ataquesConsecutivos :: Number -> Amenaza -> Ciudad -> Ciudad
ataquesConsecutivos numeroAtaques amenaza ciudad  = aplicarFuncionAIzquierda ciudad repeticiones
    where repeticiones = replicate numeroAtaques (ataqueCiudad amenaza)


-------------------------------------------------------- ¿VEMOS UNO MÁS? (grupal) --------------------------------------------------------

{-
Para contarnos la historia de las aventuras de estas chicas, esta serie está dividida en capítulos. Un capítulo incluye a un villano, el nombre de una ciudad que pretende atacar, una Chica Superpoderosa que la defiende y alimentos.

Queremos poder darlePlay a un capítulo para saber cómo afecta a una ciudad dada, que puede o no coincidir con la mencionada en el capítulo. Un villano intentará atacar a la ciudad (si es la mencionada en el capítulo) siempre que la Chica Superpoderosa, habiendo consumido sus alimentos, no pueda vencerlo. Como resultado de darlePlay a un capítulo y ciudad, vamos a conocer cómo cambia la ciudad que indicamos.
Aclaración: Un capítulo sólo puede afectar a la ciudad que nombra. Si es otra ciudad y no la que se nombra en el capítulo, entonces no le hace nada..

A su vez, los capítulos están agrupados por temporada. Una temporada no es más que una serie ordenada de capítulos. Como somos grandes maratoneros de series copadas y nos gusta que todo tenga un hilo conductor, queremos saber cómo afecta una temporada a una ciudad. Para mantener el mencionado hilo conductor, la ciudad inicia con el estado en que quedó al finalizar el capítulo anterior.

Se pide modelar el capítulo, la temporada y las funciones darlePlay/2 y maraton/2 que representan, respectivamente, el paso de un capítulo y de una temporada para una ciudad.
-}

darlePlay :: Capitulo -> Efecto
darlePlay (Capitulo amenaza nombreCiudadCapitulo chica alimentos numeroAtaques) ciudadDada
    | coincideCiudad && chicaNoPuedeVencerAmenaza = ataquesConsecutivos numeroAtaques amenaza ciudadDada
    | otherwise                                   = ciudadDada
        where coincideCiudad                      = nombreCiudadCapitulo == nombreCiudad ciudadDada
              estadoFinalChica                    = aplicarFuncionAIzquierda chica alimentos
              chicaNoPuedeVencerAmenaza           =  amenazaEsInvulnerable estadoFinalChica amenaza


type Temporada = [Capitulo]

maraton :: Temporada -> Efecto
maraton temporada ciudad = foldl (flip darlePlay) ciudad temporada

-- Capitulos

capituloSahi :: Capitulo
capituloSahi = Capitulo { amenaza = mojoJojo, nombreCiudadCapitulo = "Seul", chica = bombon, alimentos = [carameloLiquido, cocucha], numeroAtaques = 2 }

capituloAlexia :: Capitulo
capituloAlexia = Capitulo { amenaza = princesa, nombreCiudadCapitulo = "Seul", chica = bellota, alimentos = [ vodka 2, gatorei], numeroAtaques = 7 }

capituloLean :: Capitulo
capituloLean = Capitulo { amenaza = mojoJojo, nombreCiudadCapitulo = "Seul", chica = bombon, alimentos = [ saborizante "arandano", sustanciaX, fernet], numeroAtaques = 3 }

capituloBelen :: Capitulo
capituloBelen = Capitulo {amenaza = bandaGangrena, nombreCiudadCapitulo = "Seul", chica = burbuja, alimentos = [saborizante "uva", fernet, cocucha], numeroAtaques = 22 }

-- Temporada
temporadaPiloto :: Temporada
temporadaPiloto = [capituloSahi, capituloAlexia, capituloLean, capituloBelen]