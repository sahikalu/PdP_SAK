module Spec where
import PdePreludat
import Library
import Test.Hspec

correrTests :: IO ()
correrTests = hspec $ do
  describe "Test de ejemplo" $ do
    it "Se puede ir en bondi desde la ubicacion1 a la ubicacion3" $ do
      sePuedeIrEnBondi ubicacion1 ubicacion3 `shouldBe` True

