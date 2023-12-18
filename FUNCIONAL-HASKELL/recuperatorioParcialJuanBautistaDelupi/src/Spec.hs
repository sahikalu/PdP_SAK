module Spec where
import PdePreludat
import Library
import Test.Hspec

correrTests :: IO ()
correrTests = hspec $ do
  describe "Punto 1" $ do
    it "a. La madra de pino es valiosa" $ do
      (Material "Madera de pino" 25) `shouldSatisfy` esValioso
    it "b. Hay 2 unidades disponibles de acero" $ do
      unidadesDisponibles "Acero" (Aldea 50 [(Material "Acero" 15), (Material "Acero" 20), (Material "Piedra" 5)] []) `shouldBe`2
    it "c. El valor total de calidad de la aldea es 40" $ do
      valorTotal (Aldea 50 [(Material "Acero" 15), (Material "Piedra" 5)] [(Edificio "Barracas" [(Material "Acero" 20)])]) `shouldBe` 40

  describe "Punto 2" $ do
    it "c. Se recolectan 5 aceros en la aldea" $ do
      recolectar (Material "Acero" 15) 5 (Aldea 50 [] [])  `shouldBe` Aldea {poblacion = 50, materialesDisponibles = [Material {nombre = "Acero", calidad = 15},Material {nombre = "Acero", calidad = 15},Material {nombre = "Acero", calidad = 15},Material {nombre = "Acero", calidad = 15},Material {nombre = "Acero", calidad = 15}], edificios = []}

  describe "Punto 4.b." $ do
    it "i. Se tengan gnomitos 3 veces en una aldea rica (Alcanza la comida) " $ do
      realizarLasQueCumplan [tenerGnomito, tenerGnomito, tenerGnomito] tieneMasComidaQuePoblacion aldeaRica `shouldBe` Aldea {poblacion = 100, materialesDisponibles = [Material {nombre = "Comida", calidad = 15},Material {nombre = "Comida", calidad = 5},Material {nombre = "Comida", calidad = 6},Material {nombre = "Comida", calidad = 6}], edificios = [Edificio {tipoEdificio = "Barracas", materiales = [Material {nombre = "Acero", calidad = 20}]},Edificio {tipoEdificio = "Concorcity", materiales = [Material {nombre = "Marmol", calidad = 30}]}]}
    it "i. Se tengan gnomitos 3 veces en una aldea pobre (No alcanza la comida)"  $ do
      realizarLasQueCumplan [tenerGnomito, tenerGnomito, tenerGnomito] tieneMasComidaQuePoblacion aldeaPobre `shouldBe` Aldea {poblacion = 100, materialesDisponibles = [Material {nombre = "Comida", calidad = 15},Material {nombre = "Madera", calidad = 5},Material {nombre = "Cemento", calidad = 6},Material {nombre = "Comida", calidad = 6}], edificios = [Edificio {tipoEdificio = "Barracas", materiales = [Material {nombre = "Acero", calidad = 20}]},Edificio {tipoEdificio = "Concorcity", materiales = [Material {nombre = "Marmol", calidad = 30}]}]}
    it " ii. Se recolecten 30 unidades de madera de pino de calidad igual a la calidad máxima de las maderas disponibles y luego se lustren las maderas disponibles de la aldea, asegurando siempre que todos los materiales disponibles sean valiosos. " $ do
      realizarLasQueCumplan [recolectar (Material "Madera" 25) 30, lustrarMaderas] todosLosMaterialesValiosos aldeaDeMadera `shouldBe` Aldea {poblacion = 30, materialesDisponibles = [Material {nombre = "Madera", calidad = 15},Material {nombre = "Madera", calidad = 5}], edificios = []}

