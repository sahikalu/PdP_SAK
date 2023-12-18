module Spec where
import PdePreludat
import Library
import Test.Hspec

correrTests :: IO ()
correrTests = hspec $ do
  describe "Parte C" $ do
    it "Sahi lee Hello World" $ do
      (leerLibro helloWorld sahi) `shouldBe` Usuario {nick = "skalusti", indiceDeFelicidad = 100, librosAdquiridos = [], librosLeidos = [Libro {titulo = "Hello World, Primeros pasos para programar", autor = "Taylor Swift", cantidadDePaginas = 10, comoAfectanLosGenerosAlLector = [terror]}, Libro {titulo = "Hello World, Primeros pasos para programar", autor = "Taylor Swift", cantidadDePaginas = 10, comoAfectanLosGenerosAlLector = [terror]}]}
