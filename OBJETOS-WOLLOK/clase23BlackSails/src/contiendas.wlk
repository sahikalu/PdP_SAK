import blacksails.*

class Contienda {

    method puedeSuceder(ganadora, perdedora) = ganadora.puedeConflictuar(perdedora) && self.puedeGanar(ganadora,perdedora)

    method puedeGanar(ganadora, perdedora)

    method tomar(ganadora, perdedora) = {
        if (not self.puedeSuceder(ganadora, perdedora))
            throw new ContiendaException(message = "No puede suceder la contienda")
        
        self.realizarToma(ganadora, perdedora)
    }

    method realizarToma(ganadora, perdedora)

}

object batalla inherits Contienda {

    override method puedeGanar(ganadora, perdedora) = ganadora.poderDanio() > perdedora.poderDanio()

    override method realizarToma(ganadora, perdedora) {
        ganadora.sumarCorajeBase(5)
        perdedora.eliminarCobardes(3)
        perdedora.nuevoCapitan(ganadora.contramaestre())
        ganadora.promoverContramaestre()
        const masCorajudos = ganadora.masCorajudos(3)
        perdedora.agregarTripulantes(masCorajudos)
        ganadora.elminarTripulantes(masCorajudos)
    }

}

object negociacion inherits Contienda {

    override method puedeGanar(ganadora, perdedora) = ganadora.tieneHabilNegociador()

    override method realizarToma(ganadora, perdedora) {
        const medioBotin = perdedora.botin() / 2
        ganadora.variarBotin(medioBotin)
        perdedora.variarBotin(-medioBotin)
    }
}

/** esto es un ejemplo :)
object dueloCapitanes inherits Contienda {
 
}
*/

class ContiendaException inherits Exception {

}