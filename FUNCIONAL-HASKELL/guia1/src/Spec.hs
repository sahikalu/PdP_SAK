module Spec where
import PdePreludat
import Library
import Test.Hspec

correrTests :: IO ()
correrTests = hspec $ do
  describe "Test de ejemplos dados en la guia" $ do
    it "9 es multiplo de 3" $ do
      9 `shouldSatisfy` esMultiploDeTres
    it "12 es multiplo de 3" $ do
      esMultiploDe 12 3 `shouldBe` True

