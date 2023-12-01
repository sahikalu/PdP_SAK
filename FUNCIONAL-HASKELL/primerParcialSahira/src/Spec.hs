module Spec where
import PdePreludat
import Library
import Test.Hspec

ejemplo :: Auto
ejemplo = Auto {
    marca = "Ejemplo",
    modelo = "11",
    desgaste = (50, 27),
    velocidadMaxima = 44,
    tiempoDeCarrera = 0
}


correrTests :: IO ()
correrTests = hspec $ do
  describe "Test de ejemplo" $ do
    it "al reparar el auto Ejemplo queda con desgaste en el chasis de 7.5 y 0 de ruedas" $ do
      desgaste (repararAuto ejemplo) `shouldBe` (7.5, 0)

