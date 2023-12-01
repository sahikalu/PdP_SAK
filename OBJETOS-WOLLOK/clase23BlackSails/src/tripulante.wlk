import armas.*
class Tripulante {
    const armas
    var corajeBase
    const inteligencia

    method corajeBase() = corajeBase

    method coraje() = corajeBase + self.danioTotal()

    method danioTotal() = armas.sum{ arma => arma.danio()}

    method esInteligente() = inteligencia > tripulante.valorInteligencia()

    method aumentarCoraje(cantidad) {
        corajeBase += cantidad
    }

}

object tripulante {

    const property valorInteligencia = 50

}