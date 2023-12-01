// ---------------------------- Entrega 2 ----------------------------

object personaje { // companion object

	const property valorBaseHechiceria = 3 // property: quiero la regerencia, un getter y un setter
	
}

class Personaje {

	var property valorBaseLucha = 1
	var property hechizoPreferido = hechizoBasico
	const artefactos = []


	// method nivelDeHechicería() = (valor base * el poder del hechizo preferido) + valor de la fuerza orcura
	method nivelDeHechiceria() = personaje.valorBaseHechiceria() * hechizoPreferido.poder() + fuerzaOscura.valor()

	method seCreePoderoso() = hechizoPreferido.esPoderoso()

	method agregarArtefacto(artefacto) {
		artefactos.add(artefacto)
	}

	method removerArtefacto(artefacto) {
		artefactos.remove(artefacto)
	}

	method valorDeLucha() = valorBaseLucha + self.aporteDeArtefactos()
	
	method unidadesDeMejorArtefactoSin(artefacto){
		const copiaArtefactos = artefactos.copyWithout(artefacto)
		const mejorArtefacto = copiaArtefactos.max{ otro => otro.unidadesDeLucha(self) }
		return mejorArtefacto.unidadesDeLucha(self)
	}

	method aporteDeArtefactos() = artefactos.sum{ artefacto => artefacto.unidadesDeLucha(self) }

	method masLuchadorQueHechicero() = self.valorDeLucha() > self.nivelDeHechiceria()
}

object fuerzaOscura {

	var valor = 5 // no le pongo property porque me generaria un setter, y no quiero que nadie pueda cambiar el valor, así que hago el getter directamente ↓

	method valor() = valor // hago el getter directamente

	method provocarEclipse() {
		valor *= 2
	}

}

class HechizoLogos {

	const nombre
	const multiplicador

	method poder() = nombre.length() * multiplicador
	method esPoderoso() = self.poder() > 15
	
	method unidadesDeLucha(luchador) = self.poder() //TODO WTF?

}

object hechizoBasico {

	method poder() = 10

	method esPoderoso() = false
	
	method unidadesDeLucha(luchador) = self.poder() //TODO WTF?

}

object arma {
	method unidadesDeLucha(luchador) = 3
}

object collarDivino {
	var property cantidadDePerlas = 5
	
	method unidadesDeLucha(luchador) = cantidadDePerlas

}

class Mascara {
	var property unidadesMinimas = 4
	const indiceDeOscuridad
	
	method unidadesDeLucha(luchador) = unidadesMinimas.max(fuerzaOscura.valor() / 2 * indiceDeOscuridad)
}

class Armadura {
	const unidadesBase = 2
	var property refuerzo
	
	method unidadesDeLucha(luchador) = unidadesBase + refuerzo.unidadesDeLucha(luchador)
}

object bendicion {
	
	method unidadesDeLucha(luchador) = luchador.nivelDeHechiceria()
}

object refuerzoNulo {
	
	method unidadesDeLucha(luchador) = 0
}

object espejoFantastico {
	method unidadesDeLucha(luchador) = luchador.unidadesDeMejorArtefactoSin(self)
}


class LibroHechizos {
	const hechizos

	method poder() = self.hechizosPoderosos().sum{ hechizo => hechizo.poder() }
	
	method hechizosPoderosos() = hechizos.filter{ hechizo => hechizo.esPoderoso() }

	method esPoderoso() = self.hechizosPoderosos().isNotEmpty()
	
	method unidadesDeLucha(luchador) = self.poder() //TODO WTF?
	
}

