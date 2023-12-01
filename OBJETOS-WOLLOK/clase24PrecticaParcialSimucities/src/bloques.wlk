class Bloque {
    const vecinos = []
    var property cantidadPlazas = 0

    /** pto 1 */
    method estaCeloso() = vecinos.all{ vecino => vecino.estaMejorQue(self) }

    method estaMejorQue(bloque) = self.estaMejorEnEconomiaQue(bloque) or 
                                    self.tieneMasPlazasQue(bloque)

    method estaMejorEnEconomiaQue(bloque) = self.economia() > bloque.economia()

    method tieneMasPlazasQue(bloque) = cantidadPlazas > bloque.cantidadPlazas()

    method economia()

    method tienePlazas() = cantidadPlazas > 0

    method parquizar()

    /** pto 4 */
    method estaFeliz() = self.tienePlazas() and 
                            self.poblacionVecinos() > self.poblacion() and
                            not self.estaCeloso()

    method poblacionVecinos() = vecinos.sum{ vecino => vecino.poblacion()}

    method poblacion()
    method cambiarPoblacionPorcentual(porcentaje)

    method estaSuperpoblado() = false

    method agregarVecino(bloque) {
        vecinos.add(bloque)
    }

    method aumentarEconomia(valorPorcentual)
}

class BloqueResidencial inherits Bloque {
    const comercios = []
    var property poblacion
    
    override method economia() = comercios.sum{ comercio => comercio.aporte() }

    override method parquizar() {
        cantidadPlazas += poblacion.div(10000)
    }

    override method cambiarPoblacionPorcentual(porcentaje) {
        poblacion += (poblacion * porcentaje).div(100)
    }

    override method estaSuperpoblado() = poblacion > 100000

    method reorganizarHabitantes(ciudad) {
        const mitadPoblacion = poblacion.div(2)
        poblacion = mitadPoblacion
        const nuevosVecinos = ciudad.ultimosBloques(3)
        const nuevoBloque = new BloqueResidencial(poblacion = mitadPoblacion,
                                                  vecinos = nuevosVecinos)
        nuevosVecinos.forEach{ vecino => vecino.agregarVecino(nuevoBloque)}
        ciudad.agregarBloque(nuevoBloque)
    }

    override method aumentarEconomia(valorPorcentual) {
        comercios.forEach{ comercio => comercio.aumentarEconomia(valorPorcentual) }
    }

}

class BloqueIndustrial inherits Bloque {
    var nivelProduccion

    override method economia() = nivelProduccion * 1000

    override method parquizar() { }

    override method poblacion() = 0

    override method cambiarPoblacionPorcentual(porcentaje) {}

    override method aumentarEconomia(valorPorcentual) {
        nivelProduccion += (nivelProduccion * valorPorcentual).div(100)
    }

}

class Comercio {
    var property aporte

    method aumentarEconomia(valorPorcentual) {
        aporte += (aporte * valorPorcentual).div(100)
    }

}
