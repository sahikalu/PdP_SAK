module Spec where
import PdePreludat
import Library
import Test.Hspec

darthVather :: Amenaza
darthVather = Amenaza {nombreAmenaza = "Darth Vather", proposito = ["provocar corridas cambiarias", "criar mosquitos"], nivelPoder = 95, debilidades = ["reservas del banco", "exceso de la lelics", "espinaca", "deficit de atencion"], efecto = sinEfecto }

bEjemploNombreConB :: Persona
bEjemploNombreConB = Persona { nombreChica = "B ejemplo nombre con B y 1 habilidad" , nivelResistencia = 29, habilidades = ["tolerar los numeros impares"], amigos = ["bombon", "burbuja"] }
ejemploNombreSinBPeroConMasDeUnaHabilidad :: Persona
ejemploNombreSinBPeroConMasDeUnaHabilidad = Persona { nombreChica = "Ejemplo nombre sin B pero con mas de una habilidad" , nivelResistencia = 75, habilidades = ["velocidad", "superfuerza"], amigos = [] }

correrTests :: IO ()
correrTests = hspec $ do

----------------------------------------------------------- ENTREGA 1 -----------------------------------------------------------

    describe "Test AMENAZA DAÑO POTENCIAL (función danioPotencial)" $ do
      it "Mojo Jojo posee daño potencial 64" $ do
        danioPotencial mojoJojo `shouldBe` 64
      it "Princesa posee daño potencial 89" $ do
        danioPotencial princesa `shouldBe` 89
      it "Banda Gangrena posee daño potencial 40" $ do
        danioPotencial bandaGangrena `shouldBe` 40

    describe "Test AMENAZA SOBRE CIUDAD (función puedeAtacarCiudad)" $ do
      it "Mojo Jojo puede atacar Los Ángeles" $ do
        losAngeles `shouldSatisfy` puedeAtacarCiudad mojoJojo
      it "Princesa no ataca Londres " $ do
        londres  `shouldNotSatisfy` puedeAtacarCiudad princesa

    describe "Test CHICA VS AMENAZA (función venverAmenaza)" $ do
      it "Bombon no puede vencer a Mojo Jojo" $ do
        mojoJojo `shouldNotSatisfy` chicaVenceAmenaza bombon
      it "Burbuja puede vencer a Banda Gangrena" $ do
        bandaGangrena `shouldSatisfy` chicaVenceAmenaza burbuja

    describe "Test NIVEL DE AMENAZA ALTO (función nivelAmenazaAlto)" $ do
      it "Mojo Jojo posee nivel de amenaza alto" $ do
        mojoJojo `shouldSatisfy` nivelAmenazaAlto
      it "Banda Gangrena no posee nivel de amenaza alto" $ do
        bandaGangrena `shouldNotSatisfy` nivelAmenazaAlto
      it "Darth Vather posee nivel de amenaza alto" $ do
        darthVather `shouldSatisfy` nivelAmenazaAlto

----------------------------------------------------------- ENTREGA 2 -----------------------------------------------------------

    describe "Test Entrada en calor (función esInvulnerable)" $ do
      it "Mojo Jojo no es invulnerable a Burbuja" $ do
        (burbuja, mojoJojo) `shouldNotSatisfy` uncurry amenazaEsInvulnerable
      it "Mojo Jojo es invulnerable a Bombon" $ do
        (bombon, mojoJojo) `shouldSatisfy` uncurry amenazaEsInvulnerable
      it "De la lista pasada, la lista de chicas con nombre B y más de una habilidad continene a Bombon, Burbuja y Bellota" $ do
        chicasConNombreBYMasDeUnaHabilidad [ejemploNombreSinBPeroConMasDeUnaHabilidad,bombon,senioritaBelo,burbuja,bEjemploNombreConB,bellota] `shouldBe` ["Bombon","Burbuja","Bellota"]  

    describe "Test Yendo al nutricionista (funciones sustanciaX y cerveza)" $ do
      it "Burbuja se queda sin resistencia luego de consumir la sustancia X" $ do
        nivelResistencia (sustanciaX burbuja) `shouldBe` 0
      it "Bombon se queda sin resistencia luego de consumir la sustancia X" $ do
        nivelResistencia (sustanciaX bombon) `shouldBe` 0
      it "Bellota se queda sin resistencia luego de consumir la sustancia X" $ do
        nivelResistencia (sustanciaX bellota) `shouldBe` 0
      it "Burbuja toma una cerveza con la señorita Belo. Queda con 1 amigo (porque ya eran amigas)" $ do
        length (amigos (cerveza ["senioritaBelo"] burbuja)) `shouldBe` 1
      it "Burbuja toma una cerveza con silico. Queda con 2 amigos (porque ya era amiga de la señorita Belo)" $ do
        length (amigos (cerveza ["silico"] burbuja)) `shouldBe` 2
      it "Burbuja toma una cerveza con Silico y Bellota. Queda con 3 amigos (porque ya era amiga de la señorita Belo)" $ do
        length (amigos (cerveza ["silico","bellota"] burbuja)) `shouldBe` 3

    describe "Test Yendo al nutricionista (función fernet)" $ do
      it "Bellota se toma un fernet e incorpora la habilidad Chef de Asados" $ do
        habilidades (fernet bellota) `shouldBe` ["velocidad", "superfuerza","Chef de Asados"]
{-      fernet bellota `shouldSatisfy` (\habilidades -> habilidades == ["velocidad","superfuerza","Chef de Asados"])
        otro test válido -}

    describe "Test Yendo al nutricionista (función gatorei)" $ do
      it "Bellota se toma un Gatorei y la resistencia queda igual" $ do
        nivelResistencia (gatorei bellota) `shouldBe` 75
      it "Bombon se toma un Gatorei y le aumenta la resistencia a 65" $ do
        nivelResistencia (gatorei bombon) `shouldBe` 65

    describe "Test Yendo al nutricionista (función vodka)" $ do
      it "Bombon se toma 3 shots de vodka y pasa a llamarse Bom" $ do
        nombreChica (vodka 3 bombon) `shouldBe` "Bom"    
    
    describe "Test Yendo al nutricionista (función carameloLiquido)" $ do
      it "Burbuja toma caramelo liquido y queda con 20 de resistencia" $ do
        nombreChica (carameloLiquido burbuja) `shouldBe` "Burbuja"
      it "Señorita Belo toma caramelo liquido y queda con 0 de resistencia" $ do
        nombreChica (carameloLiquido senioritaBelo) `shouldBe` "Señorita Belo"

    describe "Test Yendo al nutricionista (función cocucha)" $ do
      it "Burbuja toma cocucha y no tiene velocidad" $ do
        nombreChica (cocucha burbuja) `shouldBe` "Burbuja"
      it "Señor cerdo toma cocucha y queda igual" $ do
        nombreChica (cocucha seniorCerdo) `shouldBe` "Señor Cerdo"

    describe "Test Mi villano favorito" $ do
      it "Si Mojo Jojo ataca Saltadilla, la ciudad queda con 9 habitantes" $ do
            cantidadHabitantes (ataqueCiudad mojoJojo saltadilla) `shouldBe` 9
      it "Si Princesa ataca Saltadilla, la ciudad queda con 13 habitantes" $ do
            cantidadHabitantes (ataqueCiudad princesa saltadilla) `shouldBe` 13
      it "Banda Gangrena intenta atacar Saltadilla y no puede, la ciudad queda con 17 habitantes" $ do
            cantidadHabitantes (ataqueCiudad bandaGangrena saltadilla) `shouldBe` 17
      it "Si Banda Gangrena ataca Saltadilla 2 veces consecutivas, la ciudad queda con 26 habitantes y se llama Gangrena City" $ do
            ataquesConsecutivos 2 bandaGangrena saltadilla `shouldBe` Ciudad {nombreCiudad = "Gangrena City", cantidadHabitantes = 26}
      it "Si Mojo Jojo ataca Saltadilla 4 veces consecutivas, la ciudad queda con 0 habitantes" $ do
            ataquesConsecutivos 4 mojoJojo saltadilla  `shouldBe` Ciudad {nombreCiudad = "Saltadilla", cantidadHabitantes = 0}

    describe "Test Vemos uno más (individual)" $ do
      it "Si al capituloSahi (la ciudad de Seul atacada 2 veces por Mojo Jojo y defendida por Bombón, tras una cocucha y caramelo líquido), lo evaluo con la ciudad de Seul, devuelve la ciudad de Seul con 88 habitantes" $ do
            darlePlay capituloSahi seul `shouldBe` Ciudad {nombreCiudad = "Seul", cantidadHabitantes = 88}
      it "Si al capituloSahi (la ciudad de Seul atacada 2 veces por Mojo Jojo y defendida por Bombón, tras una cocucha y caramelo líquido), lo evaluo con la ciudad de Los Angeles, no coinciden las ciudades, por lo que devuelve la ciudad de Los Angeles sin cambios" $ do
            darlePlay capituloSahi losAngeles `shouldBe` Ciudad {nombreCiudad = "Los Angeles", cantidadHabitantes = 20}

      it "Si al capituloAlexia (la ciudad de Seul atacada 7 veces por Princesa y defendida por Bellota, tras dos shots de vodka y un gatorei), lo evaluo con la ciudad de Seul, devuelve la ciudad de Seul con 44 habitantes" $ do
            darlePlay capituloAlexia seul `shouldBe` Ciudad {nombreCiudad = "Seul", cantidadHabitantes = 44}    
      it "Si al capituloAlexia (la ciudad de Seul atacada 7 veces por Princesa y defendida por Bellota, tras dos shots de vodka y un gatorei), lo evaluo con la ciudad de Londres, no coinciden las ciudades, por lo que devuelve la ciudad de Londres sin cambios" $ do
            darlePlay capituloAlexia londres `shouldBe` Ciudad {nombreCiudad = "Londres", cantidadHabitantes = 50}

      it "Si al capituloLean (la ciudad de Seul atacada 3 veces por Mojo Jojo y defendida por Bombón, tras la increíble ingesta de un saborizante de arandano, sustancia X y fernet), lo evalúo con la ciudad de Seul, devuelve la ciudad de Seúl con 82 habitantes" $ do
            darlePlay capituloLean seul `shouldBe` Ciudad {nombreCiudad = "Seul", cantidadHabitantes = 82}    
      it "Si al capituloLean (la ciudad de Seul atacada 3 veces por Mojo Jojo y defendida por Bombón, tras la increíble ingesta de un saborizante de arandano, sustancia X y fernet), lo evalúo con la ciudad de La Ferrere, no coinciden las ciudades, por lo que devuelve la ciudad de La Ferrere sin cambios" $ do
            darlePlay capituloLean laFerrere `shouldBe` Ciudad { nombreCiudad = "La Ferrere", cantidadHabitantes = 3000}

      it "Si al capituloBelen (la ciudad de Seul atacada 22 veces por Banda Gangrena y defendida por Burbuja, tras la increíble ingesta de un saborizante de uva, y un fernetazo), lo evalúo con la ciudad de Seul, devuelve la ciudad de Gangrena City con 24 habitantes" $ do
            darlePlay capituloBelen seul `shouldBe` Ciudad {nombreCiudad = "Gangrena City", cantidadHabitantes = 24}    
      it "Si al capituloBelen (la ciudad de Seul atacada 22 veces por Banda Gangrena y defendida por Burbuja, tras la increíble ingesta de un saborizante de uva, y un fernetazo), lo evalúo con la ciudad de La Matanza, no coinciden las ciudades, por lo que devuelve la ciudad de La Matanza sin cambios" $ do
            darlePlay capituloBelen laMatanza `shouldBe` Ciudad { nombreCiudad = "La Matanza", cantidadHabitantes = 45}
            
    describe "Test Vemos uno más (grupal)" $ do
      it "Hacemos maraton de la temporada piloto con la ciudad de Seul, devuelve Gangrena City con 0 habitantes" $ do 
          maraton temporadaPiloto seul `shouldBe` Ciudad {nombreCiudad = "Gangrena City", cantidadHabitantes = 0}
      it "Hacemos maraton de la temporada piloto con la ciudad de Saltadilla, devuelve Saltadilla con 21 habitantes sin hacer modificaciones porque la ciudad no forma parte de la temporada" $ do 
          maraton temporadaPiloto saltadilla `shouldBe` Ciudad {nombreCiudad = "Saltadilla", cantidadHabitantes = 21}