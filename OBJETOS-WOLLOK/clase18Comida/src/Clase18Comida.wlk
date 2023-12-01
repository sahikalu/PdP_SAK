object ensaladaRusa {
	const ingredientes = ["p", "h", "z"]
	
	method saludable() = ingredientes.size() < 5	
}

object ensaladaMixta {
	const ingredientes = ["c", "t", "l"]
	
	method saludable() = ingredientes.size() < 5	
}

object bire {
	const peso = 500
	
	method saludable() = peso < 500
}

object menu {
	const platos = []
	
	method agregar(plato) {
		platos.add(plato)
	}
	
	method sano() = platos.all({p => p.saludable()})
}

object ensaladero {
	method hacer(ing) {
		return object {
			const ingredientes = ing
			
			method saludable() = ingredientes.size() < 5
		}
	}
}

class Ensalada {
	const ingredientes = [ ]
	var precio = 10
	
	method saludable() = ingredientes.size() < 5
	
	method precio() = precio
	
	method agregar(ing) = ingredientes.add(ing)
}

const em = new Ensalada(
	ingredientes = ["c", "t", "l"], 
	precio = 15
)

const et = new Ensalada() // se crea una igual a la clase

const el = new Ensalada(precio = 50)
