module Spec where
import PdePreludat
import Library
import Test.Hspec

correrTests :: IO ()
correrTests = hspec $ do
  describe "Test de Listas" $ do
    it "La suma de los elementos de la lista [1,2,3,4,5] es 15" $ do
      sumarLista [1,2,3,4,5] `shouldBe` 15
    -- it "El promedio de las Frecuencias cardíacas de la lista dada es 115.285714285714" $ do
      -- promedioFrecuenciaCardiaca listaDeFrecuenciaCardiaca `shouldBe` 115.285714285714
    it "A los 30 min la frecuencia alcanza los 128" $ do
      frecuenciaCardiacaMinuto listaDeFrecuenciaCardiaca 30 `shouldBe` 128
    it "La lista de frecencias hasta el momento 30 es [80, 100, 120, 128]" $ do
      frecuenciasHastaMomento 30 listaDeFrecuenciaCardiaca `shouldBe` [80, 100, 120, 128]
    it "La palabrea neuquen es capicúa" $ do
      ["ne", "uqu", "en"] `shouldSatisfy` esCapicua
    it "De los horarios pasados, quien habló más minutos es el de horario reducido" $ do
      cuandoHabloMasMinutos duracionLlamadas `shouldBe` "horarioReducido"
    it "De los horarios pasados, quien hizo más llamadas es el de horario normal" $ do
      cuandoHizoMasLlamadas duracionLlamadas `shouldBe` "horarioNormal"

  describe "Test de Orden Superior" $ do
    it "Algún elemento de la tupla (1,3,5) es par" $ do
      (even, (1,3,5)) `shouldNotSatisfy` uncurry existsAny
    it "Algún elemento de la tupla (1,4,7) es par" $ do
      (even, (1,4,7)) `shouldSatisfy` uncurry existsAny
    it "Algún elemento de la tupla (1,-3,7) es menor que 0" $ do
      ((0>), (1,-3,7)) `shouldSatisfy` uncurry existsAny
    it "El resultado más alto de aplicar las funciones cuadrado y triple al numero 1 es 3 (triple)" $ do
      mejor cuadrado triple 1 `shouldBe` 3
    it "El resultado más alto de aplicar las funciones cuadrado y triple al numero 5 es 25 (cuadrado)" $ do
      mejor cuadrado triple 5 `shouldBe` 25
    it "El resultado de aplicar la función doble al par (3,12) es el par (6,24)" $ do
      aplicarPar doble (3,12) `shouldBe` (6,24)
    it "El resultado de aplicar la función even al par (3,12) es el par (False, True)" $ do
      aplicarPar even (3,12) `shouldBe` (False, True)
    it "El resultado de aplicar la función (even . doble) al par (3,12) es el par (True, True)" $ do
      aplicarPar (even . doble) (3,12) `shouldBe` (True, True)

  describe "Test de Orden Superior + Listas" $ do
    it "Alguno de los elementos de la lista [2,3,4] es múltiplo de 15" $ do
      (15, [2,3,4]) `shouldSatisfy` uncurry esMultiploDeAlguno
    it "Alguno de los elementos de la lista [3,4,5] es múltiplo de 34" $ do
      (34, [3,4,5]) `shouldNotSatisfy` uncurry esMultiploDeAlguno