  import planes.*
  
  class Pedido {
  	
  	const items = []
  	const property local
  	
  	/** pto 1 */
  	method precioBruto() = items.sum{ item => item.valor() }
  	
  	/** pto. 3.a */
  	method agregarProducto(producto, cantidad) {
  		
  		const item = self.itemPara(producto)
  		
  		// items.add(item) ... e items debe ser un Set
  		item.agregarCantidad(cantidad)
  	}
  	
  	method itemPara(producto) = items.findOrElse({ item => item.protucto() == producto }, 
  												{ const item = new Item(producto = producto) 
										  		items.add(item) // agrego el item
										  		item }) // devielvo el item
  	
  	method productos() = items.map{item => item.producto()}
  	
  	method validar() {
 		local.validarProductos(self.productos())
 	}
  	
 }
  
 class Item {
 	
 	const property producto
 	var cantidad = 0
 	
 	method valor() = producto.precio() * cantidad
 	
 	method agregarCantidad(otreCantidad) = cantidad + otreCantidad
 	
 }
  
  class Producto {
  	
  	const property precio
  	
  }
  
  class Cliente {
  	
   var plan
   const compras = []
  	
  	/** pto 2.a */
  	method costoRealEnvio(pedido) =  calculadorCuadras.costoEnvio(pedido.local(), self)
  	
  	/** pto 2.b */
  	method costoEnvio(pedido) = plan.costoEnvio(self.costoRealEnvio(pedido))
  	
  	/** pto 3.b */
  	method realizarCompra(pedido) {
  		pedido. validar()
  		
  		const nuevaCompra = compra.nuevaCompra(pedido, self.costoEnvio(pedido))
  		
  		plan.notificarNuevaCompra()
  	}
  	
  }
  
  object compra {
  	
  	method nuevaCompra(pedido, valorDeEnvio) {
  		
  		pedido.validar()
  		
  		return new Compra(pedido = pedido, valorEnvio = valorDeEnvio, fecha = new Date())
  	}
  	
  }
  
  class Local {
  	
  	const stockProductos
  	
  	method validarProductos(productos){
  		if(not productos.all{ producto => stockProductos.contains(producto) }) 
  			throw new ProductoInexistenteException(message = "No estan ")

  	}
  	
  }
  
  class ProductoInexistenteException inherits Exception {}
  
  class Compra {
  	const pedido
  	const valorEnvio
  	const fecha
  }
  
  object calculadorCuadras {
  	
  	const valorMaximo = 300
  	const propertycalorPorCuadra = 15
  	
  	method costoEnvio(local, cliente) = valorMaximo.min(self.cuadras(cliente, local) * propertycalorPorCuadra)
  	
  	method cuadras(cliente, local) = 28 // le dejo valor para los test
  	
  }