import blacksails.*

class Bestia {

    const property fuerza 

    method cruzarA(embarcacion) {
        if (fuerza > embarcacion.poderDanio())
            self.afectar(embarcacion)
    }

    method afectar(embarcacion)

}


class BallenaAzul inherits Bestia {

    override method afectar(embarcacion) {
        embarcacion.envejecerCaniones(8)
    }

}