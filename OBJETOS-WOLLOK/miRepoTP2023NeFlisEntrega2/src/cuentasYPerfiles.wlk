import contenidosYPlanes.*

/** Cuenta */
class Cuenta {

	const perfiles = #{}
	var property plan

	method nuevoPerfil(nombreNuevo, recomendacionNueva, parametroRecomendacionNueva) {
		
		const nuevoPerfil = new Perfil(
			cuenta = self, 
			nombre = nombreNuevo, 
			tipoDeRecomendacion = recomendacionNueva
		)
		
		nuevoPerfil.cambioParametros(parametroRecomendacionNueva)

		perfiles.add(nuevoPerfil)
		
		return nuevoPerfil
	}

	method cantidadDePerfiles() = perfiles.size()

	

}

/** Perfil */
class Perfil {

	const cuenta
	const nombre
	const property historial = #{}
	const property preferenciaGeneros = #{}
	const property actoresFavoritos = #{}
	var property desvio = 0
	var property tipoDeRecomendacion

	// Getters
	method plan() = cuenta.plan()

	// Acciones
	method agregarPreferencia(genero) {
		
		preferenciaGeneros.add(genero)
		
	}

	method agregarActorFavorito(actor) {
		
		actoresFavoritos.add(actor)
		
	}

	method ver(contenido) {
		
		if (self.puedeVer(contenido)) historial.add(contenido)
		
	}

	method puedeVer(contenido) = self.plan().puedeMirar(contenido)

	method valoracion() {
		
		if (historial.isEmpty()) return 0 else {
			
			const valor = historial.sum{ elem => elem.valoracion() }
			
			return valor / historial.size()
			
		}
	}

	method recomendaria(contenido) = tipoDeRecomendacion.recomendaria(contenido, self)

	method vio(contenido) = historial.contains(contenido)

	method esVariado() = tipoDeRecomendacion.esVariado(self)

	method agregarPreferenciaGeneros(nuevoSet) {
		
		preferenciaGeneros.addAll(nuevoSet)
		
	}

	method agregarActoresFavoritos(nuevoSet) {
		
		actoresFavoritos.addAll(nuevoSet)
		
	}

	method cambioParametros(parametro) {
		
		tipoDeRecomendacion.cambiarParametro(parametro, self)
		
	}

}

/** Algoritmos Recomendadores */
class AlgoritmoRecomendador {

	method recomendaria(contenido, perfil) = (not perfil.historial().contains(contenido)) and self.recomienda(contenido, perfil)

	method esVariado(perfil)

	method recomienda(contenido, perfil)

	method cambiarParametro(parametro, perfil)

}

object valoracionSimilar inherits AlgoritmoRecomendador {

	override method recomienda(contenido, perfil) {
		
		var desvioAplicado = perfil.valoracion() * perfil.desvio()
		var valoracionAlta = perfil.valoracion() + desvioAplicado
		var valoracionBaja = perfil.valoracion() - desvioAplicado
		
		return perfil.historial().isEmpty() or contenido.valoracion().between(valoracionBaja, valoracionAlta)
	}
	
	override method esVariado(perfil) = false

	override method cambiarParametro(parametro, perfil) {
		
		perfil.desvio(parametro)
		
	}

}

object preferenciaDeGenero inherits AlgoritmoRecomendador {
	
	const generosMinimosRequeridos = 5

	override method recomienda(contenido, perfil) = 
		contenido.intersect(perfil.preferenciaGeneros(), contenido.generos())

	override method esVariado(perfil) = perfil.preferenciaGeneros().size() >= generosMinimosRequeridos

	override method cambiarParametro(parametro, perfil) {
		
		perfil.agregarPreferenciaGeneros(parametro)
	
	}

}

object modoFan inherits AlgoritmoRecomendador {

	override method recomienda(contenido, perfil) = 
		contenido.intersect(perfil.actoresFavoritos(), contenido.actores())

	override method esVariado(perfil) = true

	override method cambiarParametro(parametro, perfil) {
		
		perfil.agregarActoresFavoritos(parametro)
	
	}

}

