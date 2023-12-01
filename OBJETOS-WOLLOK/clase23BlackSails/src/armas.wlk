import tripulante.*

class Canion {

    const danioBase
    var antiguedad = 0

    method danio() = (danioBase - (danioBase * canion.indiceDesgaste() * antiguedad)).max(0)

    method envejecer(cantidadAnios) {
        antiguedad += cantidadAnios
    }

}

object canion {
    const property indiceDesgaste = 0.01
    var property danioBaseFabricacion = 350

    method crear() = new Canion(danioBase = danioBaseFabricacion)

}

object cuchillo {
    var property danio = 5
    method danio(tripulante) = danio
}

class Espada {
    const danio
    method danio(tripulante) = danio
}

class Pistola {
    const calibre
    const material

    method danio(tripulante) = calibre * indexadorMateriales.indice(material)

}

//otra posible solucion
class Material {
    const property indice
}

object indexadorMateriales {
    method indice(material) = 4
}

class Insulto {
    const frase 

    method danio(tripulante) = self.palabras() * tripulante.corajeBase()

    method palabras() = frase.split(" ").size()

}