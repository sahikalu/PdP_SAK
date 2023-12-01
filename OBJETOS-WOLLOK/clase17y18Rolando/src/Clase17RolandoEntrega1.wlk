object rolando {

	const valorBaseHechiceria = 3
	var valorBaseLucha = 1
	var hechizoPreferido = hechizoBasico
	const artefactos = []

	// method nivelDeHechicería() = (valor base * el poder del hechizo preferido) + valor de la fuerza orcura
	method nivelDeHechiceria() = valorBaseHechiceria * hechizoPreferido.poder() + fuerzaOscura.valor()

	method hechizoPreferido(nuevoHechizo) {
		hechizoPreferido = nuevoHechizo
	}

	method seCreePoderoso() = hechizoPreferido.esPoderoso()

	method valorBaseLucha(nuevoValor) {
		valorBaseLucha = nuevoValor
	}

	method agregarArtefacto(artefacto) {
		artefactos.add(artefacto)
	}

	method removerArtefacto(artefacto) {
		artefactos.remove(artefacto)
	}

	method valorDeLucha() = valorBaseLucha + self.aporteDeArtefactos()

	method aporteDeArtefactos() = artefactos.sum{ artefacto => artefacto.unidadesDeLucha() }
	
	method masLuchadorQueHechicero() = self.valorDeLucha() > self.nivelDeHechiceria()

}

object fuerzaOscura {

	var valor = 5

	method valor() = valor

	method provocarEclipse() {
		valor *= 2
	}

}

object espectroMalefico {

	var nombre = "espectro maléfico"

	method poder() = nombre.length()

	method nombre(nuevoNombre) {
		nombre = nuevoNombre
	}

	method esPoderoso() = self.poder() > 15

}

object hechizoBasico {

	method poder() = 10

	method esPoderoso() = false

}

object espadaDelDestino {

	method unidadesDeLucha() = 3

}

object collarDivino {

	var cantidadDePerlas = 400

	method cantidadDePerlas(nuevaCantidad) {
		cantidadDePerlas = nuevaCantidad
	}

	method unidadesDeLucha() = cantidadDePerlas

}

object mascaraOscura {

	const unidadesMinimas = 4

	method unidadesDeLucha() = unidadesMinimas.max(fuerzaOscura.valor() / 2)

}

