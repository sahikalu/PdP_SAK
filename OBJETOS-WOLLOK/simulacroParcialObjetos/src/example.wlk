class Computadora {
	
	const property archivos = []
	const property programas = []
	var property antivirus
	
	/** 1.a */
	method agregarArchivo(archivo) { archivos.add(archivo) }
	
	method eliminarArchivo(archivo) { archivos.remove(archivo) }
	
	/** 1.b */
	method agregarPrograma(programa) { programas.add(programa) }
	
	method eliminarPrograma(programa) { programas.remove(programa) }
	
	method infectarArchivos(virus) { archivos.forEach { archivo => archivo.infectarCon(virus) } }
	
	/** 5 */
	method ejecutar(programa) { 
		
		if ( not antivirus.esMalware(programa) or antivirus == nulo) programa.ejecutarEn(self)
		
	}
	
}

class Archivo { // TODO VER si se elimina
	
	//var property nombreS
	
	method peso()
	
	method infectarCon(virus)
}

/** 2.a */
class Texto inherits Archivo {
	
	var property nombre
	var contenido
	const constanteDeDivision = 5
	
	override method peso() = ( contenido.length() + nombre.length() ) / constanteDeDivision
	
	override method infectarCon(virus) { contenido = virus.nombre() }
	
}

/** 2.b */
class Imagen inherits Archivo {
	
	var property descripcion
	var resolucion
	const constanteDeDivision = 100
	
	method nombre() = descripcion
	
	override method peso() = resolucion.pixelesTotales() / constanteDeDivision
	
	override method infectarCon(virus) { 
		
		descripcion = "Brad Pitt dentro de un caballo de madera gigante"
		
		const nuevaResolucion = new Resolucion (ancho = resolucion.alto(), alto = resolucion.ancho() ) 
		
		resolucion = nuevaResolucion
	}
	
}

class Resolucion {
	const property ancho
	const property alto
	
	method pixelesTotales() = ancho * alto
}

/** 2.c */
class Musica inherits Archivo {
	
	const nombreCancion
	var artista
	const anioDeLanzamiento
	const peso
	
	method nombre() = nombreCancion + " - " + artista
	
	override method peso() = peso
	
	override method infectarCon(virus) { if ( nombreCancion != "Pronta Entrega" ) { artista = virus.nombre() } }
	
}

class Programa {
	
	var nombre
	
	method ejecutarEn(computadora)
	
}

/** 3.a */
class Normal inherits Programa {
	
	override method ejecutarEn(computadora) {
		
		const nuevoArchivo = new Texto ( contenido = "información muy importante para el trabajo", nombre = "datos." + nombre )
		
		computadora.agregarArchivo(nuevoArchivo)
		
	}
	
}

/** 3.b */
class Virus inherits Programa {
	
	override method ejecutarEn(computadora) { computadora.infectarArchivos(self) }
	
}

/** 3.c */
class Ransomware inherits Programa {
	
	const bitcoinsAPagar
	const cuentaParaPago
	const archivosQuitados = []
	
	override method ejecutarEn(computadora)  {
		
		if ( computadora.archivos().isEmpty() and not self.pagoRealizado(computadora) )
			throw new RansomwareSinPagoException(message = "No puedo secuestrar la computadora")
		else
			if ( self.pagoRealizado(computadora) ) { archivosQuitados.forEach { archivo => computadora.agregarArchivo(archivo) } }
			else self.secuestro(computadora)
		
	}
	
	method secuestro(computadora) {
		
		archivosQuitados.addAll(computadora.archivos())
		
		computadora.archivos().clear()
		
		const datosParaPago = bitcoinsAPagar.toString() + "\n" + cuentaParaPago
		
		const readMe = new Texto ( nombre = "README", contenido = datosParaPago ) 
		
		computadora.agragarArchivos(readMe)
		
		return archivosQuitados
		
	}
	
	method pagoRealizado(computadora) =
			computadora.archivos().any{ archivo => archivo.nombre() == "Comprobante de pago" and archivo.contenido().contains(cuentaParaPago) } 
			
}

/** 4 */
class Antivirus {
	
	const baseDeVirusConocida = []
	
	method esMalware(programa) {
		if ( not self.limitacion() ) 
			throw new LimitacionException( message = "Ya no puede utilizar el antivirus. Verifique su plan")
		else return baseDeVirusConocida.contains(programa)
	}
	
	method limitacion()
	
}

class AntivirusGratuito inherits Antivirus {
	
	const fechaActual = new Date()
	var fechaDeExpiracion
	 
	
	override method limitacion() = fechaActual<=(fechaDeExpiracion)
	// method fijarfechaDeExpiracion(dia, mes, anio) { const fechaDeExpiracion = new Date (day = dia, month = mes, year = anio ) }
}

class AntivirusTrial inherits Antivirus {
	
	const chequeosMaximos
	
	var chequeoActual = 0
	
	override method limitacion() {
		
		if( chequeoActual <= chequeosMaximos ) { 
			chequeoActual++
			 return true
		}
		else return false
	}
	
}

object antivirusPago inherits Antivirus {
	
	override method limitacion() = true
}

object nulo {}


/** EXCEPCIONES */
class RansomwareSinPagoException inherits Exception {}
class LimitacionException inherits Exception {}

