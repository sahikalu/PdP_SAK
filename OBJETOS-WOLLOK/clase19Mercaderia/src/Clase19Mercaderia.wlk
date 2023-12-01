class Orden {
	
	const items
	
	method costoTotal() = items.sum { item => item.costo()}
	
}

class Item {
	
	const producto
	const cantidad
	
	method costo() =  producto.costo() * cantidad
}

class Producto { /** clase abstracta */
	
	const peso
	const valorAlmacenaje
	
	method costoDeProduccion() /** Método abstracto */
	
	method costoAlmacenaje() = peso * valorAlmacenaje
	
	method costo() = self.costoDeProduccion() + self.costoAlmacenaje()
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