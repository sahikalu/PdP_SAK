class Orden {
	
	const items = []
	
	method costoTotal() = items.sum { item => item.costo()}
	
	method productosDelicados(){
		const listaFiltrada = items.filter { item => item.esDelicado() }
		
		return listaFiltrada.sortedBy { item1, item2 => item1.nombre() < item2.nombre() }
	}
	
	method cantidadDe(nombreProducto) = items.filtes { item => item.nombre() == nombreProducto }
											 .sum {item => item.cantidad() }
											 
	method productos() = items.map { item => item.producto() }
	
}

class Item {
	
	const property producto
	const property cantidad
	
	method costo() =  producto.costo() * cantidad
	
	method esDelicado() = producto.esDelicado()
	
	method nombre() = producto.nombre()
}

class Producto { /** clase abstracta */
	
	const peso
	const valorAlmacenaje
	const property nombre = ""
	const pesoDelicado = 5
	
	method costoDeProduccion() /** Método abstracto */
	
	method costoAlmacenaje() = peso * valorAlmacenaje
	
	method costo() = self.costoDeProduccion() + self.costoAlmacenaje()
	
	method esDelicado() = peso < pesoDelicado
}


object productoComprado {
	
	const property indiceDeTraslado = 1.2
	
}

class ProductoComprado inherits Producto { /** ProductoComprado es un Producto */
	
	const precioCompra
	
	override method costoDeProduccion() = precioCompra
	
	override method costoAlmacenaje() = super() * productoComprado.indiceDeTraslado()
	
}

object productoConservado{
	
	const property costoDeConservacion = 100
}

class ProductoConservado inherits Producto { /** ProductoConservado es un Producto */
	
	const precioCompra
	var diasDeConservacion

	
	override method costoDeProduccion() = precioCompra + ( diasDeConservacion * peso * productoConservado.costoDeConservacion() )
	

}

object productoFabricado {
	
	const property costoHorasTrabajo = 500
	
}

class ProductoFabricado inherits Producto { /** ProductoFabricado es un Producto */
	
	const cantidadHorasDeTrabajo
	
	override method costoDeProduccion() = cantidadHorasDeTrabajo * productoFabricado.costoHorasTrabajo()

}

class Lote {
	
	const ordenes = []
	
	method cantidadDe(nombreProducto) = ordenes.sum { orden => orden.cantidadDe(nombreProducto) }
	
	method productos() = ordenes.flatMap { orden => orden.productos() }
								.withoutDuplicates()
								.sortedBy { producto1, producto2 => self.cantidadDe(producto1.nombre()) > self.cantidadDe(producto2.nombre()) } 
	
}