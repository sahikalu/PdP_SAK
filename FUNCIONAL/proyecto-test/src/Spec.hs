module Spec where
import PdePreludat
import Library
import Test.Hspec

correrTests :: IO ()
correrTests = hspec $ do
    describe "Test amenaza daño potencial" $ do
      it "mojo jojo da 64" $ do
        danioPotencial mojoJojo `shouldBe` 64
      it "princesa da 89" $ do
        danioPotencial princesa `shouldBe` 89
      it "banda grangrena da 40" $ do
        danioPotencial bandaGrangrena `shouldBe` 40

    describe "Test amenaza sobre ciudad" $ do
      it "mojo Jojo si ataca los angeles" $ do
        puedeAtacarCiudad mojoJojo losAngeles `shouldBe` True
      it "princesa no ataca londres " $ do
        puedeAtacarCiudad princesa londres `shouldNotBe` True
      -- intentamos hacer "mojoJojo losAngeles `shouldSatisfy` puedeAtacarCiudad" pero nos tiraba error

    describe "Test una chica puede vencer a una amenaza" $ do
      it "bombon puede vencer a mojo Jojo" $ do
        vencerAmenaza bombon mojoJojo `shouldNotBe` True
      it "burbuja puede vencer a banda grangrena" $ do
        vencerAmenaza burbuja bandaGrangrena `shouldBe` True
      -- intentamos hacer "mojoJojo losAngeles `shouldSatisfy` puedeAtacarCiudad" pero nos tiraba error

    describe "Test nivel de amenaza alto" $ do
      it "mojo Jojo es nivel de amenaza alto" $ do
        mojoJojo `shouldSatisfy` nivelAmenazaAlto
      it "banda grangrena es nivel de amenaza alto" $ do
        bandaGrangrena `shouldNotSatisfy` nivelAmenazaAlto
      it "Darth Vather es nivel de amenaza alto" $ do
        darthVather `shouldSatisfy` nivelAmenazaAlto