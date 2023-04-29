module Library where
import PdePreludat

-- Personas
bombon :: Persona
bombon = Persona { nombre = "Bombon" , nivelResistencia = 55, habilidades = ["escuchar canciones de Luciano Pereyra", "dar golpes fuertes"], amigos = [seniorCerdo, silico]}
burbuja :: Persona
burbuja = Persona { nombre = "Burbuja" , nivelResistencia = 30, habilidades = ["velocidad", "lanzar burbujas"], amigos = [señoritaBelo]}
bellota :: Persona
bellota = Persona { nombre = "Bellota" , nivelResistencia = 75, habilidades = ["velocidad", "superfuerza"], amigos = []}
señoritaBelo :: Persona
señoritaBelo = Persona { nombre = "Señorita Belo" , nivelResistencia = 10, habilidades = ["no mostrar la cara"], amigos = [burbuja]}
seniorCerdo :: Persona
seniorCerdo = Persona { nombre = "Señor Cerdo" , nivelResistencia = 0, habilidades = [], amigos = [bellota]}
silico :: Persona
silico = Persona { nombre = "Silico" , nivelResistencia = 29, habilidades = ["tolerar los numeros impares"], amigos = [bombon, burbuja]}

-- Amenazas
mojoJojo :: Amenaza
mojoJojo = Amenaza {proposito = ["destruir a las Chicas Superpoderosas"], nivelPoder = 70, debilidades = ["velocidad", "superfuerza"]}
princesa :: Amenaza
princesa = Amenaza {proposito = ["ser la unica Chica Superpoderosas"], nivelPoder = 95, debilidades = ["burbujas", "golpes fuertes"]}
bandaGangrena :: Amenaza
bandaGangrena = Amenaza {proposito = ["esparcir el caos", "hacer que todos sean flojos y peleen entre ellos"], nivelPoder = 49, debilidades = ["escuchar canciones de Luciano Pereyra", "superfuerza", "kryptonita"]}

data Persona = Persona {
    nombre :: String,
    nivelResistencia :: Number,
    habilidades :: [String],
    amigos :: [Persona]
} deriving Show

data Amenaza = Amenaza {
    proposito :: [String],
    nivelPoder :: Number,
    debilidades :: [String]
} deriving Show

data Ciudad = Ciudad {
    nombreCiudad :: String,
    cantidadHabitantes :: Number
} deriving Show

-- Calcular el daño potencial de una amenaza, el cual se calcula como el nivel de poder, menos el triple de su cantidad de debilidades.

danioPotencial  :: Amenaza -> Number
danioPotencial amenaza = nivelPoder amenaza - ((3*).length.debilidades) amenaza

-- Modelar todo lo necesario para saber si una amenaza puede atacar una ciudad. Si una amenaza tiene un daño potencial mayor al doble del número de habitantes de la ciudad, entonces puede atacar a la ciudad.


puedeAtacarCiudad :: Amenaza -> Ciudad -> Bool
--puedeAtacarCiudad amenaza ciudad = danioPotencial amenaza > ((2*). cantidadHabitantes) ciudad
puedeAtacarCiudad amenaza = (danioPotencial amenaza >).(2*). cantidadHabitantes

--Saber si una chica puede vencer a una amenaza. Si tiene longitud de propósito par, ocurre si la resistencia es mayor a la mitad del daño potencial de una amenaza. Si el propósito tiene longitud impar entonces, es suficiente que la resistencia sea mayor al daño potencial.

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
--mayorA50 amenaza = danioPotencial amenaza > 50
mayorA50 = (50<).danioPotencial

nivelAmenazaAlto :: Amenaza -> Bool
nivelAmenazaAlto amenaza = not (debilidadConKryptonita amenaza) && cantidadParDebilidades amenaza && mayorA50 amenaza


