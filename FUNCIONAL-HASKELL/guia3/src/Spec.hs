module Spec where
import PdePreludat
import Library
import Test.Hspec

correrTests :: IO ()
correrTests = hspec $ do
  describe "Test de tuplas" $ do
    it "El primer elemento de la tupla (4, 5, 6) es 4" $ do
      fst3 (4, 5, 6) `shouldBe` 4
    it "El segundo elemento de la tupla (4, 5, 6) es 5" $ do
      snd3 (4, 5, 6) `shouldBe` 5
    it "El tercer elemento de la tupla (4, 5, 6) es 6" $ do
      trd3 (4, 5, 6) `shouldBe` 6
    it "El resultado de aplicar el doble y el triple de 8 es (16, 24)" $ do
      aplicar (doble, triple) 8 `shouldBe` (16, 24)
    it "El resultado de aplicar (3+) y (2*) de 8 es (11, 16)" $ do
      aplicar ((3+), (2*)) 8 `shouldBe` (11,16)
    it "El resultado de cuentaBizarra de (5, 8) es 40" $ do
      cuentaBizarra (5, 8) `shouldBe` 40
    it "El resultado de cuentaBizarra de (8, 5) es 13" $ do
      cuentaBizarra (8, 5) `shouldBe` 13
    it "El resultado de cuentaBizarra de (5, 29) es 24" $ do
      cuentaBizarra (5, 29) `shouldBe` 24
    it "(5,6) no aprobó" $ do
      (5, 6) `shouldNotSatisfy` aprobo
    it "(6,6) aprobó" $ do
      (6, 6) `shouldSatisfy` aprobo
    it "(6,9) no promocionó" $ do
      (6, 9) `shouldNotSatisfy` promociono
    it "(7,8) promocionó" $ do
      (7, 8) `shouldSatisfy` promociono
    it "Las notas finales de ((2,7),(6,-1)) son (6,7)" $ do
      notasFinales ((2, 7), (6, -1)) `shouldBe` (6, 7)
    it "Las notas finales de ((6,7),(6,7)) son (6,7)" $ do
      notasFinales ((6, 7), (6, 7)) `shouldBe` (6, 7)
    it "Las notas finales de ((2,2),(6,2)) son (6,2)" $ do
      notasFinales ((2, 2), (6, 2)) `shouldBe` (6, 2)
    it "Las notas finales de ((8,7),(-1,-1)) son (8,7)" $ do
      notasFinales ((8, 7), (-1, -1)) `shouldBe` (8, 7)
    it "El alumno con las notas ((8, 7), (9, 10)) recuperó de gusto" $ do
      ((8, 7), (9, 10)) `shouldSatisfy` recuperoDeGusto 
    it "El alumno con las notas ((6, 7), (9, -1)) no recuperó de gusto" $ do
      ((6, 7), (9, -1)) `shouldNotSatisfy` recuperoDeGusto 
    it "Juan tiene 18 y no es mayor de edad" $ do
      ("juan",18) `shouldNotSatisfy` esMayorDeEdad 
    it "maria tiene 22 y es mayor de edad" $ do
      ("maria",22) `shouldSatisfy` esMayorDeEdad
    it "Al calcular (4, 5) me devuelve (8, 6)" $ do
      calcular (4, 5) `shouldBe` (8,6)
    it "Al calcular (3, 7) me devuelve (3, 8)" $ do
      calcular (3, 7) `shouldBe` (3, 8)


  describe "Test de funcones auxiiares" $ do
    it "5 es notaBochazo" $ do
      5 `shouldSatisfy` esNotaBochazo
    it "6 es notaBochazo" $ do
      6 `shouldNotSatisfy` esNotaBochazo

