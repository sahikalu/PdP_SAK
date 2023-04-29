module Spec where
import PdePreludat
import Library
import Test.Hspec

losAngeles :: Ciudad
losAngeles = Ciudad { nombreCiudad = "Los Angeles", cantidadHabitantes = 20}
londres :: Ciudad
londres = Ciudad { nombreCiudad = "Londres", cantidadHabitantes = 50}

darthVather :: Amenaza
darthVather = Amenaza {proposito = ["provocar corridas cambiarias", "criar mosquitos"], nivelPoder = 95, debilidades = ["reservas del banco", "exceso de la lelics", "espinaca", "deficit de atencion"]}

correrTests :: IO ()
correrTests = hspec $ do
    describe "Test de daño potencial de una Amenaza (función danioPotencial)" $ do
      it "Mojo Jojo da 64" $ do
        danioPotencial mojoJojo `shouldBe` 64
      it "Princesa da 89" $ do
        danioPotencial princesa `shouldBe` 89
      it "Banda Gangrena da 40" $ do
        danioPotencial bandaGangrena `shouldBe` 40

    describe "Test de si una Amenaza puede atacar una ciudad (función puedeAtacarCiudad)" $ do
      it "Mojo Jojo puede atacar Los Angeles" $ do
        losAngeles `shouldSatisfy` puedeAtacarCiudad mojoJojo
      it "Princesa no puede atacar Londres " $ do
        londres  `shouldNotSatisfy` puedeAtacarCiudad princesa

    describe "Test de si una Chica Superpoderosa puede vencer a una Amenaza (función chicaVenceAmenaza)" $ do
      it "Bombón no puede vencer a mojo Jojo" $ do
        mojoJojo `shouldNotSatisfy` chicaVenceAmenaza bombon
      it "Burbuja puede vencer a Banda Gangrena" $ do
        bandaGangrena `shouldSatisfy` chicaVenceAmenaza burbuja  

    describe "Test de si el nivel de una Amenaza es alto (función nivelAmenazaAlto)" $ do
      it "Mojo Jojo posee nivel de amenaza alto" $ do
        mojoJojo `shouldSatisfy` nivelAmenazaAlto
      it "Banda Gangrena no posee nivel de amenaza alto" $ do
        bandaGangrena `shouldNotSatisfy` nivelAmenazaAlto
      it "Darth Vather posee nivel de amenaza alto" $ do
        darthVather `shouldSatisfy` nivelAmenazaAlto
