module Spec where
import PdePreludat
import Library
import Test.Hspec

{-
correrTests :: IO ()
correrTests = hspec $ do
  describe "Test de Huber" $ do
    it "el precio del viaje de la ubicacion 1 a la 2 es de $5" $ do
      importeEnHuber ubicacion1 ubicacion2 `shouldBe` 5
    it "se puede ir en bondi de la ubicacion 1 a la 3" $ do
      sePuedeIrEnBondi ubicacion1 ubicacion3 `shouldBe` True
    it "el bondi 14 es más barato que un huber para ir de la ubicacion 1 a la 2" $ do
      masBaratasQueHuber ubicacion1 ubicacion2 `shouldBe` [14]
    it "la distancia en cuadras de la ubicacion 1 a la 2 es de 8" $ do
      distanciaEntre ubicacion1 ubicacion2 ubicaciones `shouldBe` 8
-}