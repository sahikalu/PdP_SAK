import excepciones.*

class Cazador {
	
	/* cosnidero que monsturosCazados y objetos son listas ya que se podrían repetir elementos en ambos, un cazador podría cazar a un monstruo 2 veces 
	(si en algún momebto escapó por ejemplo o podría tener 2 bicicletas) */
	const property monsturosCazados = []
	const property objetos = []
	var nivelDestreza 
	
	method nivelDestreza() = nivelDestreza
	
	method atrapar(monstruo) {
		
		if (objetos == (monstruo.todasSusDebilidades()) and self.condicionParaAtraparKraken(monstruo)) { monsturosCazados.add(monstruo) }
		else { monstruo.daniar(self) }
		
	}

	method condicionParaAtraparKraken(monstruo) { /** Adición para el PUNTO 5 */
		
		if (monstruo.equals(kraken)) return nivelDestreza > 1000 
		else return true
		
	}
		
	method perderObjetos() { objetos.clear() }
	
	method nivelDestreza(valor) { nivelDestreza = valor}
	
	method liberarUltimoMonstruo() { self.liberarUltimo(monsturosCazados) }
	
	method liberarUltimoObjeto() { self.liberarUltimo(objetos) }
	
	method liberarUltimo(lista) {
		
		const ultimoElemento = lista.last()
		
		lista.remove(ultimoElemento)
		
	}
	
	method cantidadDeMonstruosCazados() = monsturosCazados.size()
	
	method investigar(caso) { caso.investigar(self) }
	
	method agregarObjeto(nuevoObjeto) { objetos.add(nuevoObjeto) }
	
	method monstruoMasJodido() = monsturosCazados.sortedBy { monstruo1 , monstruo2 => monstruo1.nivelDeJodido() > monstruo2.nivelDeJodido() }.take(1)
	
	method cantidadDeMonstruosFacilesDeAtrapar() = monsturosCazados.filter { monstruo => monstruo.cantidadDeDebilidades() == 1 }.size()
	
	method reducirDestrezaSegunPuntos() = 0.max(nivelDestreza - objetos.size())
	
}

class Monstruo {
	
	// inicializo las variables, ya que las puedo agregar cuando creo un nuevo monstruo
	const property objetosParaSuCaza = []
	const property objetoMonstrual = nulo 
	
	method todasSusDebilidades() { 
		
		if (not objetoMonstrual.equals(nulo)) {
			
			const debilidades = objetosParaSuCaza.copy()
			
			debilidades.add(objetoMonstrual)
			 
			return debilidades
		 
		}
		else return objetosParaSuCaza // considero que si el monstruo no tiene objetosParaSuCaza, entonces sus debilidades solo son objetosParaSuCaza
		
	}
	
	method objetosParaSuCaza()
	
	method agregarObjetosParaSuCaza(objetosNuevos) { objetosParaSuCaza.addAll(objetosNuevos) }
	
	method daniar(cazador) {}
	
	method objetosParaSuCaza(objetos) { objetosParaSuCaza.addAll(objetos)} 
	
	// method perderObjeto() { objetosParaSuCaza.anyOne() } // considero que todos los monstruos tiene objetosParaSuCaza, por lo que la lista nunca está vacía
	
	method cantidadDeDebilidades() = self.todasSusDebilidades().size()
	
	method inscribirseEn(concurso) = concurso.inscribir(self)
	
	method nivelDeJodido() = self.todasSusDebilidades().size()
	
}

class Banshees inherits Monstruo {
	
	override method objetosParaSuCaza() = ["hierro", "sal"]
	
	override method daniar(cazador) { cazador.perderObjetos() }
	
}

class Curupi inherits Monstruo {
	
	override method objetosParaSuCaza() = ["hacha"]
	
	override method daniar(cazador) { cazador.nivelDestreza(cazador.nivelDestreza() / 2)} 
	
}

class LuzMala inherits Monstruo {
	
	override method daniar(cazador) { cazador.nivelDestreza(cazador.reducirDestrezaSegunPuntos()) }	
}

class Djinn inherits Monstruo {
	
	override method daniar(cazador) { 
		
		if (not cazador.monsturosCazados().isEmpty()) {
			
			cazador.nivelDestreza(cazador.nivelDestreza() - 1)
			
			cazador.liberarUltimoMonstruo()
		
		}
		else {} // considero que si un cazador no cazó monstruos, no se puede liberar nada, pero el Djinn está enojado y no escucha ni razones ni excepciones 🤣
	} 
	
}

/** Adición para el PUNTO 5 */
object kraken inherits Monstruo {} // no conozco el desarrollo del kraken

class Crimen {
	
	const objeto
	
	method investigar(cazador) { cazador.agregarObjeto(objeto) }
	
}

class Trampa {
	
	method investigar(cazador) { cazador.liberarUltimoObjeto() }
	
}

class Avistaje {

	const puntosASumar 
	
	method investigar(cazador) { cazador.nivelDestreza(puntosASumar) }
	
}

class Concurso {
	
	const participantes = [] // inicializo la lista considerando que no las personas no se inscriben 2 veces. Debe ser lista para poder darle un orden
	
	method condicionIncripcion(cazador) /** me devuelve un bool (como se ve en el ejemplo de la línea 179) */
	
	method inscribir(cazador) { 
		
		if (not self.condicionIncripcion(cazador)) 
			throw new InscripcionException (message = "No se cumplen las condiciones para la inscripción")
		else { participantes.add(cazador) }
		
	}
	
	method podioPorCantidadDeMonstruos() = participantes.sortedBy { cazador1 , cazador2 => cazador1.cantidadDeMonstruosCazados() > cazador2.cantidadDeMonstruosCazados() }.take(3) 
	
	method podioPorMonstruoMasJodido() = participantes.sortedBy { cazador1 , cazador2 => cazador1.monstruoMasJodido() > cazador2.monstruoMasJodido() }.take(3)
	
	method podioPorElMasHolgazan() = participantes.sortedBy { cazador1 , cazador2 => cazador1.cantidadDeMonstruosFacilesDeAtrapar() > cazador2.cantidadDeMonstruosFacilesDeAtrapar() }.take(3)
	
}


/** Ejemplo de lo desarrollado en la línea 160 */
object elRamboGuarani inherits Concurso {
	
	const minimoDeMonstruosCazados = 10
	
	override method condicionIncripcion(cazador) = cazador.cantidadDeMonstruosCazados() <= minimoDeMonstruosCazados
	
}

object nulo {}

/** PUNTO 5 

Hay que hacer cambios, ya que en mi modelo debo modificar el metodo "condicionParaAtrapar" para que considere el caso de que sea un kraken (línea 20) , en caso de ser así tambien considero 
que el cazador tenga una destreza superior a 1000.
A su vez, al ser un UNICO kraken, tuve que crear el objeto krakaen (línea 133) para poder hacer la comparación explicada ya arriba y también tuve que verificar que todos estados esten 
inicializados, porque sino el objeto no puede heredar la clase Montruo sin inicializar la constante y no conozco los detalles. Esto teniendo en cuenta que las listas ya las tenía inicializadas vacías y el 
"objetoMonstrual" inicializado con el objeto nulo (considerando que hay casos en los que los monstruos no cuentan con dichos objetos).

*/
