{-# LANGUAGE BlockArguments #-}
module Spec where
import PdePreludat
import Library
import Test.Hspec

losAngeles :: Ciudad
losAngeles = Ciudad { nombreCiudad = "Los Angeles", cantidadHabitantes = 20}
londres :: Ciudad
londres = Ciudad { nombreCiudad = "Londres", cantidadHabitantes = 50}

darthVather :: Amenaza
darthVather = Amenaza {nombreAmenaza = "Darth Vather", proposito = ["provocar corridas cambiarias", "criar mosquitos"], nivelPoder = 95, debilidades = ["reservas del banco", "exceso de la lelics", "espinaca", "deficit de atencion"]}

bEjemploNombreConB :: Persona
bEjemploNombreConB = Persona { nombreChica = "B ejemplo nombre con B y 1 habilidad" , nivelResistencia = 29, habilidades = ["tolerar los numeros impares"], amigos = ["bombon", "burbuja"]}
ejemploNombreSinBPeroConMasDeUnaHabilidad :: Persona
ejemploNombreSinBPeroConMasDeUnaHabilidad = Persona { nombreChica = "Ejemplo nombre sin B pero con mas de una habilidad" , nivelResistencia = 75, habilidades = ["velocidad", "superfuerza"], amigos = []}

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
        (burbuja, mojoJojo) `shouldNotSatisfy` uncurry esInvulnerable
      it "Princesa es invulnerable a Burbuja" $ do
        (burbuja, princesa) `shouldSatisfy` uncurry esInvulnerable
      it "De la lista pasada, la lista de chicas con nombre B y más de una habilidad continene a Bombon, Burbuja y Bellota" $ do
        chicasConNombreBYMasDeUnaHabilidad [ejemploNombreSinBPeroConMasDeUnaHabilidad,bombon,senioritaBelo,burbuja,bEjemploNombreConB,bellota] `shouldBe` ["Bombon","Burbuja","Bellota"]
    
    --describe "Test Entrada en calor (función chicasVencenAmenza)" $ do
    --  it "la lista de chicas que vencen a mojo jojo" $ do
    --    chicasVencenAmenza [bellota,bombon,burbuja] mojoJojo `shouldBe` ["Bellota"]    

    describe "Test Yendo al nutricionista (funciones mostrarResultadosSustanciaX y cervezaConAmigos)" $ do
      it "Burbuja se queda sin resistencia luego de consumir la sustancia X" $ do
        mostrarResultadoSustanciaX burbuja `shouldBe` 0
      it "Bombon se queda sin resistencia luego de consumir la sustancia X" $ do
        mostrarResultadoSustanciaX bombon `shouldBe` 0
      it "Bellota se queda sin resistencia luego de consumir la sustancia X" $ do
        mostrarResultadoSustanciaX bellota `shouldBe` 0
      it "Burbuja toma una cerveza con la señorita Belo. Queda con 1 amigo (porque ya eran amigas)" $ do
        cervezaConAmigos burbuja ["senioritaBelo"] `shouldBe` 1
      it "Burbuja toma una cerveza con silico. Queda con 2 amigos (porque ya era amiga de la señorita Belo)" $ do
        cervezaConAmigos burbuja ["silico"] `shouldBe` 2
      it "Burbuja toma una cerveza con Silico y Bellota. Queda con 3 amigos (porque ya era amiga de la señorita Belo)" $ do
        cervezaConAmigos burbuja ["silico","bellota"] `shouldBe` 3

    describe "Test Yendo al nutricionista (función consumeFernet)" $ do
      it "Bellota se toma un fernet e incorpora la habilidad Chef de Asados" $ do
        consumeFernet bellota `shouldBe` ["velocidad","superfuerza","Chef de Asados"]
{-      consumeFernet bellota `shouldSatisfy` (\habilidades -> habilidades == ["velocidad","superfuerza","Chef de Asados"])
        otro test válido -}

    describe "Test Yendo al nutricionista (función consumeGatorei)" $ do
      it "Bellota se toma un Gatorei y la resistencia queda igual" $ do
        consumeGatorei bellota `shouldBe` 75
      it "Bombon se toma un Gatorei y le aumenta la resistencia a 65" $ do
        consumeGatorei bombon `shouldBe` 65

    describe "Test Yendo al nutricionista (función consumeVodka)" $ do
      it "Bombon se toma 3 shots de vodka y pasa a llamarse Bom" $ do
        consumeVodka bombon 3 `shouldBe` "Bom"    
    
    describe "Test Yendo al nutricionista (función consumeCarameloLiquido)" $ do
      it "Burbuja toma caramelo liquido y queda con 20 de resistencia" $ do
        consumeCarameloLiquido burbuja `shouldBe` 20       
      it "Señorita Belo toma caramelo liquido y queda con 0 de resistencia" $ do
        consumeCarameloLiquido senioritaBelo `shouldBe` 0 

    describe "Test Yendo al nutricionista (función consumeCocucha)" $ do
      it "Burbuja toma cocucha y no tiene velocidad" $ do
        consumeCocucha burbuja `shouldBe` ["lanzar burbujas"]               
      it "Señor cerdo toma cocucha y queda igual" $ do
        consumeCocucha seniorCerdo `shouldBe` []
    
