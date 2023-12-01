import errores.*
import camiones.*

/** State Pattern */
class EstadoCamion {
	
	method nombre()
	
	method puedeCargar(camion, coso) = false
	
	method validarCarga(camion, coso) {
		throw new CargaException(message = "Camión '" + self.nombre() + "'. Estado incorrecto")
	}
	
	method salirDeReparacion(camion) {
		throw new TransicionException(message = "No se puede salir de reparación en estado " + self.nombre())
	}
	
	method entrarEnReparacion(camion) {
		throw new TransicionException(message = "No se puede entrar en reparación en estado " + self.nombre())
	}
	
	method estaListoParaPartir(camion) = false
	
	method estaEnViaje() = false

	method estaCargando(camion) = false
	
}



object disponibleParaCarga inherits EstadoCamion {
	
	const property nombre = "Disponible Para Carga"
	
	override method puedeCargar(camion, coso) = camion.puedeCargarPeso(coso)
	
	override method validarCarga(camion, coso) { 
		camion.validarCoso(coso)
	}
	
	override method entrarEnReparacion(camion){ 
		camion.estado(enReparacion)
	}
	
	override method estaListoParaPartir(camion) = camion.tienePesoSuficienteParaPartir()
	
	override method estaCargando(camion) = not camion.tienePesoSuficienteParaPartir()
	
}


object enReparacion inherits EstadoCamion {
	
	const property nombre = "En Reparación"
	
	override method salirDeReparacion(camion) {
		camion.estado(disponibleParaCarga)
	}
	
}


object enViaje inherits EstadoCamion {
	
	const property nombre = "En Viaje"
	
	override method estaEnViaje() = true
	
}
