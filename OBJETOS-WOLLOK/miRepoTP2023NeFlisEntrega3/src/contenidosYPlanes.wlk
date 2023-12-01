import cuentasYPerfiles.*
import excepciones.*

/** Contenido */
class Contenido {

	const property titulo
	const property generos = #{}
	const property actores = #{}
	var property plan
	var property esEstreno

	method plan() = plan

	// interseccion entre dos sets
	method hayInterseccion(lista1, lista2) = lista1.any({ elemento1 => lista2.contains(elemento1) })

}

class Pelicula inherits Contenido {

	const property duracion

	method valoracion() = self.generos().size() * 12

}

class Serie inherits Contenido {

	const property temporadas
	const property cantidadDeCapitulos
	const property duracionCapitulo
	const contenidoDeTemporada = #{}

	method valoracion() = temporadas * cantidadDeCapitulos

	// si bien no se utiliza, realizamos el método por la consigna
	method agregarCapitulo(nombreNuevoCapitulo) {
		
		if (contenidoDeTemporada.size() < cantidadDeCapitulos) {
		
		const capitulo = new Capitulo(nombre = nombreNuevoCapitulo, duracion = duracionCapitulo)
		
		contenidoDeTemporada.add(capitulo)
	
		}

}

	method verContenidoDeTemporada() { 
		
		const nombresCapitulos = #{}
		
		contenidoDeTemporada.forEach { capitulo => nombresCapitulos.add(capitulo.nombre()) }
		
		return nombresCapitulos
		
	}

}

class Capitulo {

	const property nombre
	const property duracion

}

class EstadoContenido {
	
	const property contenido
	var porcentajeVisto
	var puntaje = 0
	
	method porcentaje() = porcentajeVisto
	
	method puntaje() = puntaje
	
	// Considerando que un usuario puede retroceder en el capitulo, por lo que puede haber vito el 50% y luego rectroceder y volver al 25% O que puede volver a ver un contenido
	method actualizar(porcentaje) { 
		
		if (self.rangoDeCarga(porcentajeVisto) and self.rangoDeCarga(porcentaje)) {
			
			porcentajeVisto = porcentaje
			
		}
	} 
	
	method rangoDeCarga(porcentaje) = porcentaje >= 1 and porcentaje < 100
	
	method puntuar(puntajeNuevo) {
		
		if (puntajeNuevo >= 1 and puntajeNuevo <= 5) { puntaje = puntajeNuevo }
		
	}
	
	method valoracion() = contenido.valoracion()
	
	method generos() = contenido.generos()
	
	method actores() = contenido.actores()
	
}

/** Plan */
object planPremium {

	method puedeMirar(contenido) = true
}

object planBasico {

	method puedeMirar(contenido) = contenido.plan().equals(self)

}
