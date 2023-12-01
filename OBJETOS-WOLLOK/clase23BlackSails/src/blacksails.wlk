import armas.*
import tripulante.*

class Embarcacion {

    const caniones
    const tripulacion
    const property ubicacion
    var botin

    /** pto 1 */
    method poderDanio() = tripulacion.corajeTotal() + self.danioCaniones()

    method danioCaniones() = caniones.sum{ canion => canion.danio() }

    /** pto 2 */
    method tripulanteMasCorajudo() = tripulacion.pirataMasCorajudo()

    /** pto 3 */
    method puedeConflictuar(otraEmbarcacion) = ubicacion.estaCerca(otraEmbarcacion.ubicacion())

    method tieneHabilNegociador() = tripulacion.tieneHabilNegociador()

    method botin() = botin

    method variarBotin(cantidad) {
        botin += cantidad
    }

    method sumarCorajeBase(cantidad) {
        tripulacion.sumarCorajeBase(cantidad)
    }

    method eliminarCobardes(cantidad) {
        tripulacion.eliminarCobardes(cantidad)
    }
    
    method envejecerCaniones(cantidadAnios) {
        caniones.forEach{ canion => canion.envejecer(cantidadAnios) }
    }
}

class Ubicacion {
    const property oceano
    const property x
    const property y

    method estaCerca(otraUbicacion) = oceano == otraUbicacion.oceano() && self.estaEnRangoConflicto(otraUbicacion)

    method estaEnRangoConflicto(otraUbicacion) = ((x - otraUbicacion.x()).square() + (y - otraUbicacion.y()).square()  ).squareRoot() < ubicacion.rangoMaximoConflicto()

}

object ubicacion {
    var property rangoMaximoConflicto = 100
}

class Tripulacion {
    var capitan
    var contramaestre
    const piratas

    method corajeTotal() = self.tripulacion().sum{ tripulante => tripulante.coraje() }
    
    method tripulacion() {
        const tripulantes = piratas.copy()
        tripulantes.addAll([capitan, contramaestre])
        return tripulantes
    }

    method pirataMasCorajudo() = piratas.max{ pirata => pirata.coraje() }

    method tieneHabilNegociador() = self.tripulacion().any{ tripulante => tripulante.esInteligente() }

    method sumarCorajeBase(cantidad) {
        self.tripulacion().forEach{ tripulante =>
            tripulante.aumentarCoraje(cantidad) }
    }

    method eliminarCobardes(cantidad) {
        const masCobardes = piratas.sortedBy{ p1, p2 => p1.coraje() < p2.coraje() }.take(3)
        piratas.removeAll(masCobardes)
    }
    
}
