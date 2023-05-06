module Spec where
import PdePreludat
import Library
import Test.Hspec

correrTests :: IO ()
correrTests = hspec $ do
  describe "Test de ejemplo Aplicación Parcial" $ do
    it "el siguiente de 3 es 4" $ do
      siguiente 3 `shouldBe` 4
    it "la mitad de 5 es 2.5" $ do
      mitad 5 `shouldBe` 2.5
    --it "la inversa de 4 es 0.2" $ do
      --inversa 4 `shouldBe` 0.2
    --it "la inversa de 0.5 es 2.0" $ do
      --inversa 0.5 `shouldBe` 2.0
    it "el triple de 5 es 15" $ do
      triple 5 `shouldBe` 15
    it "-5 es no numero positvo" $ do
      (-5) `shouldNotSatisfy` esNumeroPositivo
    it "0.99 es numero positvo" $ do
      0.99 `shouldSatisfy` esNumeroPositivo
  describe "Test de ejemplo Composición" $ do
    it "9 es multiplo de 3" $ do
      esMultiploDe 9 3 `shouldBe` True
    it "2023 no es año bisiesto" $ do
      2023 `shouldNotSatisfy` esBisiesto
    it "2020 año bisiesto" $ do
      2020 `shouldSatisfy` esBisiesto
    it "la inversa de la raiz cuadrada de 4 es 0.5" $ do
      inversaRaizCuadrada 4 `shouldBe` 0.5
    it "3 inscrementado al cuadrado de 2 es 11" $ do
      incrementMCuadradoN 3 2 `shouldBe` 11
    it "2 elevado a la 5 tiene resultado par" $ do
      esResultadoPar 2 5 `shouldBe` True
    it "3 elevado a la 2 no tiene resultado par" $ do
      esResultadoPar 3 2 `shouldBe` False