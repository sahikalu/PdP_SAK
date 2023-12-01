import artefactos.*

class Hechizo {
	
	method poder()
	
	method esPoderoso()
	
	method precio() = self.poder()

	method unidadesDeLucha(luchador) = self.poder()
	
	method precio(armadura) = armadura.unidadesBase() + self.poder()
	
	method pesoRefuerzo() = 
		if (self.poder().even()) 
			2
		else 
			1

}

class HechizoLogos inherits Hechizo {

	const nombre
	var property multiplicador

	override method poder() = nombre.length() * multiplicador
	
	override method esPoderoso() = self.poder() > 15

}

object hechizoBasico inherits Hechizo {

	override method poder() = 10
	
	override method precio() = 10
	
	override method esPoderoso() = false

}

class LibroHechizos inherits Hechizo {
	
	const hechizos

	override method poder() = self.hechizosPoderosos().sum{ hechizo => hechizo.poder() }
	
	method hechizosPoderosos() = hechizos.filter{ hechizo => hechizo.esPoderoso() }

	override method esPoderoso() = self.hechizosPoderosos().isNotEmpty()
	
	override method precio() = hechizos.size() * 10 + self.poder()
	
}

object hechizoComercial inherits HechizoLogos(nombre = "el hechizo comercial", multiplicador = 2) {
	
	var porcentajePoder = 0.2
	
	override method poder() = super() * porcentajePoder 
	
	
}