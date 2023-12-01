import contenidosYPlanes.*
import excepciones.*

object limiteDeEdad {
	var property valor = 13
}

object fecha {
	const property hoy = new Date()
	
	method esMenor(fechaDeNacimiento) = hoy < fechaDeNacimiento.plusYears(limiteDeEdad.valor())
}

/** Cuenta */
class Cuenta {

	const perfiles = #{}
	var property plan

	method nuevoPerfil(nombreNuevo, 
					   recomendacionNueva, 
					   parametroRecomendacionNueva, 
					   diaNacimiento, 
					   mesNacimiento, 
					   anioNacimiento){
		
		const fechaNacimientoNueva = new Date (day = diaNacimiento, 
											   month = mesNacimiento, 
											   year = anioNacimiento)

		var recomendacion = recomendacionNueva
		
		if (fecha.esMenor(fechaNacimientoNueva)) { recomendacion = controlParental }
		
		const nuevoPerfil = new Perfil(
									   cuenta = self, 
									   nombre = nombreNuevo, 
									   tipoDeRecomendacion = recomendacion,
									   fechaDeNacimiento = fechaNacimientoNueva)
		
		nuevoPerfil.cambioParametros(parametroRecomendacionNueva)

		perfiles.add(nuevoPerfil)
		
		return nuevoPerfil
	}
	
	method nuevoPerfil(nombreNuevo, 
					   diaNacimiento, 
					   mesNacimiento, 
					   anioNacimiento) {
		
		const fechaNacimientoNueva = new Date (day = diaNacimiento, 
											   month = mesNacimiento, 
											   year = anioNacimiento)
		
		const recomendacionNueva = self.limitesPerfil(nombreNuevo,fechaNacimientoNueva)
		
		return self.nuevoPerfil(nombreNuevo, 
								recomendacionNueva, 
								#{}, 
								diaNacimiento, 
								mesNacimiento, 
								anioNacimiento)
	
	}
	
	method limitesPerfil(nombreNuevo,fechaNacimientoNueva) {
		
		if (not fecha.esMenor(fechaNacimientoNueva)) return porDefecto
		else return controlParental
		
	}

	method cantidadDePerfiles() = perfiles.size()

}

/** Perfil */
class Perfil {

	const cuenta
	const property nombre
	const property historial = #{}
	const property preferenciaGeneros = #{}
	const property actoresFavoritos = #{}
	var property desvio = 0
	var tipoDeRecomendacion
	const fechaDeNacimiento


	method plan() = cuenta.plan()
	
	method tipoDeRecomendacion() = tipoDeRecomendacion
	
	method fechaDeNacimiento() = fechaDeNacimiento


	// Agregado actores y preferencias
	method agregarPreferencia(genero) { preferenciaGeneros.add(genero) }

	method agregarPreferenciaGeneros(nuevoSet) { preferenciaGeneros.addAll(nuevoSet)}
	
	method agregarActorFavorito(actor) { actoresFavoritos.add(actor)}
	
	method agregarActoresFavoritos(nuevoSet) { actoresFavoritos.addAll(nuevoSet)}


	// Porcentaje de Contenido Visto
	method ver(nuevoContenido, porcentaje) {
		
		if (not self.puedeVer(nuevoContenido))
			throw new PlanException (message = "El título no corresponde al plan actual")
		else 
			{ self.verHasta(nuevoContenido, porcentaje) }
	}

	method verHasta(nuevoContenido, porcentaje) {
		
		const estadoContenido = new EstadoContenido(contenido = nuevoContenido, 
													porcentajeVisto = porcentaje)
		
		if (historial.contains(estadoContenido)) 
		
			{ estadoContenido.actualizar(porcentaje) }
		else 
			{ historial.add(estadoContenido) }
		
	}

	method porcentajeVistoDe(contenido) { 
	
		if(self.vio(contenido)) {
			
			const estadoContenido = self.buscarEnHistorial(contenido)
			
			return estadoContenido.porcentaje()
			
		}
		
		else return 0
		
	}


	method puedeVer(contenido) = self.plan().puedeMirar(contenido)

	method valoracion() {
		
		if (historial.isEmpty()) return 0 else {
			
			const valor = historial.sum{ elem => elem.valoracion() }
			
			return valor / historial.size()
			
		}
	}

	method vio(contenido) = self.historialContiene(contenido)
	
	method esVariado() = tipoDeRecomendacion.esVariado(self)

	method cambioParametros(parametro) {
		
		tipoDeRecomendacion.cambiarParametro(parametro, self)
		
	}
	
	//Puntuación
	method puntuar(contenidoABuscar, puntaje) {
		
		const elemento = self.buscarEnHistorial(contenidoABuscar)
		
		elemento.puntuar(puntaje)
		
	}
	
	method puntaje(contenido) {
		
		const elemento = self.buscarEnHistorial(contenido)
		
		return elemento.puntaje()
	}
	
	// Manejo del Historial
	method buscarEnHistorial(contenidoABuscar) = historial.find { 
		estadoContenido => estadoContenido.contenido() == contenidoABuscar
	}
	
	method historialContiene(contenidoABuscar) = historial.any { 
		estadoContenido => estadoContenido.contenido() == contenidoABuscar
	}
	
	method filtrarHistorialPor(puntaje) = historial.filter { 
		estadoContenido => estadoContenido.puntaje() == puntaje
	}
	
	// Tipos de Recomendaciones
	
	method recomendaria(contenido) = tipoDeRecomendacion.recomendaria(contenido, self)
	
	method cambiarTipoDeRecomendacion(nuevaRecomentacion) {
		
		if (not cuenta.esMenor(fechaDeNacimiento)) { tipoDeRecomendacion = nuevaRecomentacion }
		
	}
	
	method tipoDeRecomendacion(nuevoTipo) {
		
		if (fecha.esMenor(fechaDeNacimiento) and not nuevoTipo.equals(controlParental))
		
			throw new MenorDeEdadException (message ="Tipo de recomendación no accesible para menores de edad.") 
		
		else {tipoDeRecomendacion = nuevoTipo} 
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
	 
		contenido.hayInterseccion(perfil.preferenciaGeneros(), contenido.generos())

	override method esVariado(perfil) = perfil.preferenciaGeneros().size() >= generosMinimosRequeridos

	override method cambiarParametro(parametro, perfil) {
		
		perfil.agregarPreferenciaGeneros(parametro)
	
	}

}

object modoFan inherits AlgoritmoRecomendador {

	override method recomienda(contenido, perfil) =
	 
		contenido.hayInterseccion(perfil.actoresFavoritos(), contenido.actores())

	override method esVariado(perfil) = true

	override method cambiarParametro(parametro, perfil) {
		
		perfil.agregarActoresFavoritos(parametro)
	
	}

}

object controlParental inherits AlgoritmoRecomendador {

	override method recomienda(contenido, perfil) = contenido.generos().contains("Infantil")

	override method esVariado(perfil) = true
	
	override method cambiarParametro(parametro, perfil) {}

}

object porDefecto inherits AlgoritmoRecomendador {

	override method recomienda(contenido, perfil) {
		
		if (perfil.filtrarHistorialPor(0) == perfil.historial()) return contenido.esEstreno()
		
		else {
			
			const contenidoQueLeGustoBastante =  perfil.filtrarHistorialPor(4) + perfil.filtrarHistorialPor(5)
			
			contenidoQueLeGustoBastante.forEach { estadoContenido => 
				
				perfil.agregarPreferenciaGeneros(estadoContenido.generos())
				
				perfil.agregarActoresFavoritos(estadoContenido.actores())  
			}
		
			return preferenciaDeGenero.recomendaria(contenido, perfil) or 
				   modoFan.recomendaria(contenido, perfil)
				
		}
	
	}

	override method esVariado(perfil) = true

	override method cambiarParametro(parametro, perfil) {
		
		perfil.desvio(parametro)
		
	}
}