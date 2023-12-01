// -------------------------------------- USUARIOS --------------------------------------

object cosmeFulanito {

	var plan = planBasico
	const historial = []
	const preferencias = [ 'Accion', 'Aventuras' ]

	method plan() = plan

	method preferencias() = preferencias

	method agregarPreferencia(genero) {
		preferencias.add(genero)
	}

	method nuevoPlan(nuevoPlan) {
		plan = nuevoPlan
	}

	method ver(contenido) {
		if (self.puedeVer(contenido)) {
			historial.add(contenido)
			
			return "${contenido} incluido en la lista de cosas vistas"
		} else {
			return "${contenido} no disponible con el plan actual"
		}
	}

	method puedeVer(contenido) = plan.puedeMirar(contenido)

	method valoracion() {
		if (historial.isEmpty()) return 0 
		else {
			var valor = historial.sum { elem => elem.valoracion() }
			
			return valor / historial.size()
		}
	}

	method recomendacion(contenido) {
		if (contenido.tipoDeContenido() == 'Pelicula' and not (self.intersect(preferencias, contenido.generos()).isEmpty())) return true
		if (contenido.tipoDeContenido() == 'Serie' and self.tieneGeneroPreferido(contenido)) return true
		return contenido.tipoDeContenido() == 'Documental' and self.tieneGeneroPreferido(contenido)
	}

	// encontrar la intersección entre ambas listas
	method intersect(preferencia, generos) {
		return preferencia.filter{ preferencia1 => generos.contains(preferencia1) }
	}

	// verificar si al menos un elemento de preferencias está en contenido.generos()
	method tieneGeneroPreferido(contenido) {
		return preferencias.any{ genero => contenido.generos().contains(genero) }
	}

}

object margoZavala {

	var plan = planPremium
	const historial = []
	var desvio = 0.15

	method nuevoDesvio(nuevoDesvio) {
		desvio = nuevoDesvio
	}

	method plan() = plan

	method nuevoPlan(nuevoPlan) {
		plan = nuevoPlan
	}

	method ver(contenido) {
		if (self.puedeVer(contenido)) {
			historial.add(contenido)
			
			return "${contenido} incluido en la lista de cosas vistas"
		} else {
			return "${contenido} no disponible con el plan actual"
		}
	}

	method puedeVer(contenido) = plan.puedeMirar(contenido)

	method valoracion() {
		if (historial.isEmpty()) return 0 
		else {
			var valor = historial.sum { elem => elem.valoracion() }
			
			return valor / historial.size()
		}
	}

	method recomendacion(contenido) {
		var valoracionAlta = self.valoracion() + (self.valoracion() * desvio)
		var valoracionBaja = self.valoracion() - (self.valoracion() * desvio)
		
		return historial.isEmpty() or (contenido.valoracion()).between(valoracionBaja, valoracionAlta)
	}

}

// -------------------------------------- PLANES --------------------------------------

object planBasico {

	const contenidoDisponible = [ blackSails, avengersEndgame ]

	method puedeMirar(contenido) = contenidoDisponible.contains(contenido)

}

object planPremium {

	const contenidoDisponible = [ blackSails, avengersEndgame, seanEternos ]

	method puedeMirar(contenido) = contenidoDisponible.contains(contenido)

}

// -------------------------------------- CONTENIDOS --------------------------------------

object blackSails {

	const tipoDeContenido = 'Serie'
	const temporadas = 4
	const capitulos = 8
	const generos = 'Accion'

	method tipoDeContenido() = tipoDeContenido

	method valoracion() = temporadas * capitulos

	method generos() = generos

}

object avengersEndgame {

	const tipoDeContenido = 'Pelicula'
	const generos = [ 'Accion', 'Drama', 'Aventuras' ]

	method tipoDeContenido() = tipoDeContenido

	method valoracion() = generos.size() * 12

	method generos() = generos

}

object seanEternos {

	const tipoDeContenido = 'Documental'
	const genero = [ 'Documental' ]

	method tipoDeContenido() = tipoDeContenido

	method valoracion() = 100

	method generos() = genero

}
