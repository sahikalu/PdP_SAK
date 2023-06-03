module Library where
import PdePreludat

-- CurryCoin
--1-------------------------------------------------------------------
--1.a
type Id = String
data Cuenta = Cuenta {
    idCuenta :: Id,
    saldo :: Number
} deriving (Show,Eq)

type Transaccion = Cuenta -> Cuenta
type Bloque = [(Id, Transaccion)]

--1.b
transaccion numero cuenta = cuenta{ saldo = numero + saldo cuenta}

pago,cobro,transaccion :: Number -> Transaccion
pago numero = transaccion (-numero)
cobro = transaccion
mineria :: Transaccion
mineria = transaccion 25

--2-------------------------------------------------------------------
--2.a
correspondeId identificador = (identificador==).idCuenta 

--2.b
primeraQueCumple condicion cuentas = head . filter condicion $ cuentas

--2.c
sinLaPrimeraQueCumple condicion cuentas = takeWhile (/=primera) cuentas ++ tail (dropWhile (/=primera) cuentas)
    where primera = primeraQueCumple condicion cuentas

--3-------------------------------------------------------------------
modificarCuenta identificador cuentas trx = trx (primeraQueCumple esId cuentas) : sinLaPrimeraQueCumple esId cuentas
    where esId = correspondeId identificador


--4-------------------------------------------------------------------
afectar bloque cuentas = foldl aplicarTrx cuentas bloque
    where aplicarTrx cs (identificador, trx) = modificarCuenta identificador cs trx

--5-------------------------------------------------------------------



--6-------------------------------------------------------------------
type Blockchain = [Bloque]

-- chequeo cuentas = all sonEstables . foldr (\bloque estados -> afectar bloque (head estados) : estados) [cuentas] -- opcion 1
-- afectar bloque : afectar bloque cuentas : [cuentas]
-- chequeo blockchain cuentas = all (sonEstables . foldr afectar cuentas . flip take blockchain) [1..length blockchain] -- opcion 2

--7-------------------------------------------------------------------
--funcionSinPudor:: [[c]] -> ( (c -> Number), ( a -> a ) ) -> ( a -> a )