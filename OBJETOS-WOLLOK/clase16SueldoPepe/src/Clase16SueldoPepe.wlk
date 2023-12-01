// EJERCICIO 3 Guía 1  - SUELDO PEPE

object pepe {
	var puesto = cadete
	var bonoPorPresentismo = nulo
	var faltas = 0
	var bonoPorResultado = nulo

	method sueldo() = puesto.neto() + bonoPorPresentismo.valor(self) + bonoPorResultado.valor(self)
	
	method puesto(nuevoPuesto) {
		puesto = nuevoPuesto
	}
	
	method bonoPorPresentismo(nuevoBonoPorPresentismo) {
		bonoPorPresentismo = nuevoBonoPorPresentismo
	}
	
	method bonoPorResultado(nuevoBonoPorResultado) {
	bonoPorResultado = nuevoBonoPorResultado
	}
	
	method neto() = puesto.neto()
	
	method faltas() = faltas
	
	method faltas(nuevasFaltas){
		faltas = nuevasFaltas
	}
}

object gerente {
	method neto() = 1000
}

object cadete {
	method neto() = 1500
}

object presentismo {
	method valor(empleado) =
		if (empleado.faltas() == 0)
			100
		else if (empleado.faltas() == 1)
			50
		else
			0
			
	/*
	//  OTRA FORMA DE PONERLO:
	method valor(faltas){
		if (faltas == 0)
			return 100
		else if (faltas == 1)
			return 50
		else
			return 0
	}
	*/
}

object resultadoVariable{
	method valor(empleado) = empleado.neto() / 10 // Y NOOOOOOO VA empleado.puesto.neto()
}

object resultadoFijo{
	method valor(empleado) = 80
}

// NULL OBJECT
object nulo{
	method valor(empleado) = 0
}




// PEPE AHORA ES GERENTE Y QUIERE SABER EL SUELDO DE TODOS SUS EMPLEADOS

/*
object pepe {
	const empleados = []

	var puesto = cadete
	var bonoPorPresentismo = nulo
	var faltas = 0
	var bonoPorResultado = nulo

	method sueldo() = puesto.neto() + bonoPorPresentismo.valor(self) + bonoPorResultado.valor(self)
	
	method puesto(nuevoPuesto) {
		puesto = nuevoPuesto
	}
	
	method bonoPorPresentismo(nuevoBonoPorPresentismo) {
		bonoPorPresentismo = nuevoBonoPorPresentismo
	}
	
	method bonoPorResultado(nuevoBonoPorResultado) {
	bonoPorResultado = nuevoBonoPorResultado
	}
	
	method neto() = puesto.neto()
	
	method faltas() = faltas
	
	method faltas(nuevasFaltas){
		faltas = nuevasFaltas
	}
	
	method totalSueldos() = empleados.sum{empleado => empleado.sueldo()} // es lo mismo que hacer un "sum.map(\ e -> sueldo e) $ empleados" en Haskell 
}

object gerente {
	method neto() = 1000
}

object cadete {
	method neto() = 1500
}

object presentismo {
	method valor(empleado) =
		if (empleado.faltas() == 0)
			100
		else if (empleado.faltas() == 1)
			50
		else
			0
			
	/*
	//  OTRA FORMA DE PONERLO:
	method valor(faltas){
		if (faltas == 0)
			return 100
		else if (faltas == 1)
			return 50
		else
			return 0
	}
	*/ /*
}

object resultadoVariable{
	method valor(empleado) = empleado.neto() / 10 // Y NOOOOOOO VA empleado.puesto.neto() 
}

object resultadoFijo{
	method valor(empleado) = 80
}

// NULL OBJECT
object nulo{
	method valor(empleado) = 0
}

*/