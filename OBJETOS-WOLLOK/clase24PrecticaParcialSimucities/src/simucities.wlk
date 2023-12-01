import bloques.*
class Ciudad {
    const bloques = []
    const historialPbiPerCapita = []

    /** pto 2 */
    method esVerde() = bloques.all{ bloque => bloque.tienePlazas() }

    /** pto 3 */
    method parquizar() { 
        bloques.forEach{ bloque => bloque.parquizar() }
    }

    /** pto 5 */
    method pbiPerCapita() =  self.pbiTotal() / self.poblacion()

    method pbiTotal() = bloques.sum{ bloque => bloque.economia() }

    method poblacion() = bloques.sum{ bloque => bloque.poblacion() }
     
    /** pto 6 */
    method economiaOk() {
        // generar issue para zip / zipWith
        const ultimos = collectionUtils.zip(self.ultimosTrimestres().copyWith(self.pbiPerCapita()))
        return ultimos.all{ tuple => tuple.fst() < tuple.snd() }  
    } 

    method ultimosTrimestres() = historialPbiPerCapita.reverse().take(2).reverse()

    /** pto 7 */                        
    method suceder(evento) {
        const pbiPerCapitaActual = self.pbiPerCapita()
        // Idea pto 8
        // const nuevaCiudad = new Ciudad(ciudadAnterior=self,...)
        // evento.sucederEn(nuevaCiudad)
        // return nuevaCiudad
        evento.sucedeEn(self)
        historialPbiPerCapita.add(pbiPerCapitaActual)
        
    }

    method cambiarPoblacionPorcentual(porcentaje) {
        bloques.forEach{ bloque => bloque.cambiarPoblacionPorcentual(porcentaje) }
    }

    method reorganizarHabitantes() {
        bloques.filter{ bloque => bloque.estaSuperpoblado() }
                .forEach{ bloque => bloque.reorganizarHabitantes(self) }
    }
    
    method ultimosBloques(cantidad) = bloques.reverse().take(cantidad)

    method agregarBloque(bloque) {
        bloques.add(bloque)
    }

    method aumentarEconomia(valorPorcentual) {
        bloques.forEach{ bloque => bloque.aumentarEconomia(valorPorcentual)}
    }
     
}

object cambioPoblacion {

    method sucedeEn(ciudad) {
        if (ciudad.economiaOk())
            ciudad.cambiarPoblacionPorcentual(5)
        else 
            ciudad.cambiarPoblacionPorcentual(-1)
        
        ciudad.reorganizarHabitantes()
    }

}

class CrecimientoEconomico {
    const valor

    method sucedeEn(ciudad) {
        if (ciudad.pbiPerCapita() > crecimientoEconomico.limiteDeCrecimiento() and ciudad.economiaOk()) {
            ciudad.aumentarEconomia(valor)
            //TODO efecto PBI Per capita > 1000
        }
    }
}

object crecimientoEconomico {
    var property limiteDeCrecimiento = 600
}

class CrecimientoMixto {
    const crecimientoEconomico

    method sucedeEn(ciudad) {
        cambioPoblacion.sucedeEn(ciudad)
        crecimientoEconomico.sucedeEn(ciudad)
    }

}



object collectionUtils {

    method zip(collection) =
        (0..collection.size() - 2).map{ index =>
            new Tuple(fst= collection.get(index),
                        snd = collection.get(index+1) )
        }
    
}


class Tuple {
    const property fst
    const property snd

    override method ==(other) = other.fst() == fst and other.snd() == snd
}