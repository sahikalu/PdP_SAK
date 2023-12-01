import cuentasYPerfiles.*
import contenidosYPlanes.*
import excepciones.*

/** PELICULAS */

const avengersEndgame = new Pelicula(
	titulo = "Avengers Endgame",
	generos = #{"Acción", "Drama", "Aventura", "Ciencia Ficción"},
	duracion = 182,
	actores =  #{"Robert Downey Jr.", "Chris Evans", "Mark Ruffalo", "Chris Hemsworth", "Scarlett Johansson", 
		"Jeremy", "Don Cheadle", "Paul Rudd", "Benedict Cumberbatch", "Chadwick Boseman", "Brie Larson", 
		"Tom Holland", "Karen Gillan", "Zoe Saldana"},
	plan = planBasico,
	esEstreno = true
)
	
const eternoResplandor = new Pelicula(
	titulo = "El eterno resplandor de una mente sin recuerdos",
	generos = #{"Drama"," Romance"," Ciencia Ficción"},
	duracion = 108, 
	actores = #{"Jim Carrey", "Kate Winslet", "Gerry Robert Byrne", "Elijah Wood"},
	plan = planBasico,
	esEstreno = false
)

const laMascara = new Pelicula(
	titulo = "La máscara",
	generos = #{"Comedia","Fantasía"},
	duracion = 101, 
	actores = #{"Jim Carrey", "Cameron Diaz", "Peter Greene", "Peter Riegert"},
	plan = planBasico,
	esEstreno = false
)

const it = new Pelicula( 
	titulo = "It",
	generos = #{"Terror"},
	duracion = 135,
	actores = #{"Jaeden Martell", "Jeremy Ray Taylor"," Sophia Lillis", "Finn Wolfhard", "Chosen Jacobs"},
	plan = planPremium,
	esEstreno = false
)

const millenium = new Pelicula(
	titulo = "Millennium 2: La chica que soñaba con una cerilla y un bidón de gasolina",
	generos = #{"Acción", "Crimen", "Drama", "Misterio", "Suspenso"},
	duracion = 129,
	actores = #{"Michael Nyqvist", "Noomi Rapace", "Lena Endre"},
	plan = planPremium,
	esEstreno = false
)

const elementos = new Pelicula(
	titulo = "Elementos", 
	generos = #{"Animación", "Comedia", "Fantasía"},
	duracion = 101,
	actores = #{"Leah Lewis", "Mamoudou Athie", "Ronnie Del Carmen", "Shila Ommi"},
	plan = planBasico,
	esEstreno = true
)


/** SERIES */

const seanEternos = new Serie(
	titulo = "Sean Eternos",
	generos = #{"Documental"},
	actores = #{"Lionel Messi", "Angel Di Maria", "Xavi Hernández", "Luis Suarez"},
	temporadas = 1, 
	cantidadDeCapitulos = 3, 
	duracionCapitulo = 50,
	plan = planPremium,
	esEstreno = true
)

const goodOmens = new Serie(
	titulo = "Good Omens",
	generos = #{"Fantasía", "Comedia", "Drama"},
	actores = #{"David Tennant", "Michael Sheen"},
	temporadas = 6,
	cantidadDeCapitulos = 6,
	duracionCapitulo = 50,
	plan = planPremium,
	esEstreno = false
)

const blackSails = new Serie( 
	titulo = "Black Sails",
	generos = #{"Acción"," Drama", "Aventuras"},
	actores = #{"Toby Stephens", "Luke Arnold", "Toby Schmitz", "Hannah New", "Jessica Parker Kennedy"},
	temporadas = 4,
	cantidadDeCapitulos = 8,  
	duracionCapitulo = 45,
	plan = planBasico,
	esEstreno = true
)


const theWitcher = new Serie(
	titulo = "The Witcher",
	generos = #{"Acción", "Fantasía", "Drama", "Misterio"},
	actores = #{"Henry Cavill", "Freya Allan", "Anya Chalotra"},
	temporadas = 3,
	cantidadDeCapitulos = 8, 
	duracionCapitulo = 60, 
	plan = planBasico,
	esEstreno = true
)

/** PERFILES */

const margoZavala = new Perfil(
	cuenta = cuentaMargoZavala,
	nombre = "Margo Zavala",
	desvio = 0.15,
	tipoDeRecomendacion = valoracionSimilar,
	fechaDeNacimiento = new Date (day = 10, month = 1, year = 2000)
)

const cosmeFulanito = new Perfil(
	cuenta = cuentaMargoZavala,
	nombre = "Cosme Fulanito",
	tipoDeRecomendacion = preferenciaDeGenero,
	preferenciaGeneros = #{"Acción", "Aventura"},
	fechaDeNacimiento = new Date (day = 10, month = 2, year = 2000)
)

const donBarredora = new Perfil(
	cuenta = cuentaDonBarredora,
	nombre = "Don Barredora",
	tipoDeRecomendacion = modoFan,
	actoresFavoritos = #{"Robert Downey Jr.","Toby Stephens", "Luke Arnold", "Henry Cavill"},
	fechaDeNacimiento = new Date (day = 10, month = 3, year = 2000)
)
 
/** CUENTAS */

const cuentaMargoZavala = new Cuenta(plan = planPremium, perfiles = #{margoZavala, cosmeFulanito})

const cuentaDonBarredora = new Cuenta(plan = planBasico)
