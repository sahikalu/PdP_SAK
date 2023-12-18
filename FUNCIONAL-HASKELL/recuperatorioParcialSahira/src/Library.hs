module Library where
import PdePreludat

doble :: Number -> Number
doble numero = numero + numero

-- 1.  Molelar les usuaries

data Usuario = Usuario {
    nick :: String,
    indiceDeFelicidad :: Number,
    librosAdquiridos :: [Libro],
    librosLeidos :: [Libro]
} deriving (Show, Eq)

-- 2. Molelar Libros

data Libro = Libro {
    titulo :: String,
    autor :: String,
    cantidadDePaginas :: Number,
    comoAfectanLosGenerosAlLector :: [Usuario -> Usuario]
} deriving (Show, Eq)

-- 3. Ejemplo De Usuario

sahi :: Usuario
sahi = Usuario { nick = "skalusti", indiceDeFelicidad = 100, librosAdquiridos = [helloWorld, barney], librosLeidos = [helloWorld] }

-- 4. Da un ejemplo de libro.

helloWorld :: Libro
helloWorld = Libro { titulo = "Hello World, Primeros pasos para programar", autor = "Taylor Swift", cantidadDePaginas = 10, comoAfectanLosGenerosAlLector = [terror] }

barney :: Libro
barney = Libro { titulo = "Barney", autor = "Taylor Swift", cantidadDePaginas = 10, comoAfectanLosGenerosAlLector = [comediaDramatica] }

-- Parte B
-- a. Las comedias dependen de su tipo de humor:

comedia :: (Number -> Number) -> Usuario -> Usuario
comedia modificacionAlNivelDeFelicidad lector = lector { indiceDeFelicidad = modificacionAlNivelDeFelicidad . indiceDeFelicidad $ lector }

-- i. Las comedias dramáticas no alteran a quien las lee.

comediaDramatica :: Usuario -> Usuario
comediaDramatica lector = lector

-- ii. Las comedias absurdas aumentan en 5 el índice de felicidad.

comediaAbsurda :: Usuario -> Usuario
comediaAbsurda = comedia (+ 5)

-- iii. Las comedias satíricas duplican el índice de felicidad.

comediaSatirica :: Usuario -> Usuario
comediaSatirica = comedia (* 2)

-- iv. El resto de comedias le suman 10 al índice de felicidad.

comediaNormal :: Usuario -> Usuario
comediaNormal = comedia (+ 10)

-- b. Los de ciencia ficción tienen un impacto muy especial, ya que las personas que los leen quieren un nombre raro por lo que invierten los caracteres de su nick.

cienciaFiccion :: Usuario -> Usuario
cienciaFiccion lector = lector { nick = reverse . nick $ lector }

-- c. Los de terror hacen huir con pavor a quienes los leen, por lo que regalan todos sus libros adquiridos, haciendo que abandonen la lectura… PARA SIEMPRE MUAJAJA.

terror :: Usuario -> Usuario
terror lector = lector { librosAdquiridos = [] }

-- Parte C
-- a. Cuando una persona lee un libro el mismo pasa a formar parte de sus libros leídos y además ocurren los efectos del género.

leerLibro :: Libro -> Usuario -> Usuario
leerLibro libroALeer lector = lectorYaAfectado { librosLeidos = libroALeer : librosYaLeidos  }
    where lectorYaAfectado = generosAfectanAlLector lector libroALeer
          librosYaLeidos = librosLeidos lector

generosAfectanAlLector :: Usuario -> Libro -> Usuario
generosAfectanAlLector lector libro = foldl generoAfectaAlLector lector comoAfectanLosGenerosAlLectorDelLibro
    where comoAfectanLosGenerosAlLectorDelLibro = comoAfectanLosGenerosAlLector libro
          generoAfectaAlLector lector genero = genero lector

-- b. Cuando una persona se pone al día lee todos los libros adquiridos que no haya leído previamente. Decimos que una persona leyó un libro si entre los libros que leyó hay alguno con el mismo título que haya sido escrito por la misma persona.

ponerseAlDia :: Usuario -> Usuario
ponerseAlDia lector = foldl (flip leerLibro) lector librosNoLeidos
    where librosNoLeidos = filter (not . tieneLibroLeido lector) librosYaAdquiridos
          librosYaAdquiridos = librosAdquiridos lector

tieneLibroLeido :: Usuario -> Libro -> Bool
tieneLibroLeido lector libro = any (mismoAutorYTitulo libro) librosYaLeidos
    where librosYaLeidos = librosLeidos lector

mismoAutorYTitulo :: Libro -> Libro -> Bool
mismoAutorYTitulo libro1 libro2 = mismoTitulo libro1 libro2 && mismoAutor libro1 libro2

mismoAlgoEntreLibros :: Eq t => (Libro -> t) ->  Libro -> Libro -> Bool
mismoAlgoEntreLibros algo libro1 libro2 = algo libro1 == algo libro2

mismoTitulo :: Libro -> Libro -> Bool
mismoTitulo = mismoAlgoEntreLibros autor

mismoAutor :: Libro -> Libro -> Bool
mismoAutor = mismoAlgoEntreLibros autor

-- c. Algunas personas se fanatizan con quienes escriben los libros, es por ello que queremos saber si una persona es fanática de un escritor o escritora; esto sucede cuando todos los libros que leyó fueron escritos por esa autora o autor. 

esFanaticoDeUnEscritor :: Usuario -> Bool
esFanaticoDeUnEscritor lector = all (mismoAutor primerLibro) librosYaLeidos
    where primerLibro = head . librosLeidos $ lector
          librosYaLeidos = librosLeidos lector

{-  d. ¿Puede una persona ponerse al día si adquirió una cantidad infinita de libros? Justificar.

"ponerseAlDia" usa "foldl (flip leerLibro) lector librosNoLeidos" para iterar sobre la lista "librosNoLeidos". Pero si la lista de "librosNoLeidos" es infinita, el "foldl" intentará evaluar todos esos libros antes de devolver algún resultado. Debido a la Lazy Evaluation, Haskell trataría de seguir evaluando la lista infinita, pero como nunca termina, nunca obtendríamos un resultado.

Por lo que una persona no podría ponerse al día si ha adquirido una cantidad infinita de libros, ya que siempre habrían más libros por evaluar.

-}

-- Parte D
-- a. Los libros con menos de 100 páginas son cuentos.

--tipoDeLibroSegunCantidadDePaginas :: (Number -> Number) -> Libro -> Bool
tipoDeLibroSegunCantidadDePaginas :: (Number -> Bool) -> Libro -> Bool
tipoDeLibroSegunCantidadDePaginas parametroDeComparacion = parametroDeComparacion . cantidadDePaginas

-- a. Los libros con menos de 100 páginas son cuentos.
cuento :: Libro -> Bool
cuento = tipoDeLibroSegunCantidadDePaginas (< 100)

-- b. Los libros que tengan entre 100 y 200 páginas son novelas cortas. 
novelaCorta :: Libro -> Bool
novelaCorta libro = mayorQue100 libro && menorQue200 libro
    where mayorQue100 = tipoDeLibroSegunCantidadDePaginas (>= 100)
          menorQue200 = tipoDeLibroSegunCantidadDePaginas (<= 200)

-- c. Los libros con más de 200 páginas son novelas. 
novela :: Libro -> Bool
novela = tipoDeLibroSegunCantidadDePaginas (> 200)

-- d. Para finalizar queremos poder saber los títulos de los libros que una persona adquirió dado un tipo de libro en específico (cuentos, novelas cortas o novelas). 

titulosSegunTipoDeLibro :: (Libro -> Bool) -> Usuario -> [Libro]
titulosSegunTipoDeLibro tipoDeLibro lector = filter tipoDeLibro libros
    where libros =  librosAdquiridos lector