object fiat600 {
	var tanque = 0

	method cargarNafta(litros){
		/* 
		tanque = tanque + litros 
		tanque <= 27
		*/
		tanque = 27.min(tanque + litros)
	}
	method 	viajar(km){
		self.consumirNafta(self.rendimiento(km)) /* me asigno como receptor */
	}
	method encender(){
		self.consumirNafta(0.2) /* me asigno como receptor */
	}
	method consumirNafta(litros){
	/* 
	tanque = tanque - litros
	tanque >= 0
	*/
	tanque = 0.max(tanque - litros)
	}
	method podesViajar(km) = tanque > self.rendimiento(km)
	method rendimiento(km) = km * 0.1
	
	method tanque() = tanque
}

object meteoro {
	const auto = fiat600

	method irAlLaburo(){
		if(not auto.meAlcanzaParaElViaje(5)){
			auto.cargarNafta(10)
		}

		auto.viajar(5)
	}
	method meAlcanzaParaElViaje(km){
		 auto.podesViajar(2 * km)
	}
}