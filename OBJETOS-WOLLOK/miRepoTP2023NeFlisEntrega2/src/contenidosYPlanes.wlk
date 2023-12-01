import cuentasYPerfiles.*

/** Contenido */
class Contenido {

	const property titulo
	const property generos = #{}
	const property actores = #{}
	var property plan

	method plan() = plan

	// interseccion entre dos sets
	method intersect(lista1, lista2) = lista1.any({ elemento1 => lista2.contains(elemento1) })

}

class Pelicula inherits Contenido {

	const property duracion

	

	method valoracion() = self.generos().size() * 12

}

class Serie inherits Contenido {

	const property temporadas
	const property cantidadDecapitulos
	const property duracionCapitulo
	const contenidoDeTemporada = #{}

	method valoracion() = temporadas * cantidadDecapitulos

	// si bien no se utiliza, realizamos el método por la consigna
	method agregarCapitulo(nuevoCapitulo) {
		
		const capitulo = new Capitulo(nombre = nuevoCapitulo, duracion = duracionCapitulo)
		contenidoDeTemporada.add(capitulo)
	
	}

}

class Capitulo {

	const property nombre
	const property duracion

}

/** Plan */
object planPremium {

	method puedeMirar(contenido) = true

}

object planBasico {


	method puedeMirar(contenido) = contenido.plan().equals(self)

}

