
class Coso {
	/** 13a */
	const property destino
	const property temperaturaMaxima 
}

class Bulto inherits Coso {
	
	const pesoPallet
	const caja
	const cantidadCajas
	
	method peso() = caja.peso() * cantidadCajas + pesoPallet
	
	method contenido() = caja.contenido()
	
}


class Caja inherits Coso {
	
	const property peso
	const property contenido
	
}


class Bidon inherits Coso {
	
	const capacidad
	const liquido
	
	method peso() = capacidad * liquido.densidad()
	
	method contenido() = liquido.nombre()
	
}


class Liquido {
	const property nombre
	const property densidad
}


