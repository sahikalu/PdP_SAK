import cosos.*
import estados.*
import errores.*

class Camion {
	
	const cosos = []
	const cargaMaxima
	var property estado
	
	/** pto 1 & 3 */
	method cargar(coso) {
		estado.validarCarga(self, coso)
		
		cosos.add(coso)
	}
	
	method validarCoso(coso) {
		if (not self.puedeCargarPeso(coso))
			throw new CargaException(message = "Peso máximo excedido")
	}
	
	/** pto 2 */
	method puedeCargar(coso) = estado.puedeCargar(self, coso)
		
	method puedeCargarPeso(coso) = coso.peso() + self.cargaActual() <= cargaMaxima
	
	method cargaActual() = cosos.sum{ coso => coso.peso() }
	
	/** pto 4 */
	method salirDeReparacion() = estado.salirDeReparacion(self) 
	
	/** pto 4 */
	method entrarEnReparacion() = estado.entrarEnReparacion(self)
	
	/** pto 5 */
	method estaListoParaPartir() = estado.estaListoParaPartir(self)
	
	method tienePesoSuficienteParaPartir() = (cargaMaxima * 0.75) <= self.cargaActual()
	
	method estaEnViaje() = estado.estaEnViaje()
	
	/** pto 7 */
	method elementos() = cosos.map{ coso => coso.contenido() }.asSet()
	
	method estaCargando(elemento) = estado.estaCargando(self) && self.tiene(elemento)
	
	method tiene(elemento) = self.elementos().contains(elemento)
	
}

class CamionFrigorifico inherits Camion {
	
	/** 13c & d */
	override method validarCoso(coso) {
		super(coso)
		
		if (not self.soportaTemperatura(coso))
			throw new CargaException(message = "Temperatura no soportada")
	}
	
	method soportaTemperatura(coso) = 
		coso.temperaturaMaxima() >= camionFrigorifico.temperaturaMaxima() 
	
}

object camionFrigorifico {
	
	var property temperaturaMaxima = 0
}


class Deposito {
	
	const camiones
	
	/** pto 6 */
	method cargaTotalEnViaje() = self.camionesEnViaje().sum{ camion => camion.cargaActual() }
	
	method camionesEnViaje() = camiones.filter{ camion => camion.estaEnViaje() }
	
	/** pto 8 */
	method camionesCargando(elemento) = camiones.filter{ camion => camion.estaCargando(elemento) }
	
	
}