package esercizio16

// Interfacce con implementazione di default
interface Smartphone {
    fun takePhoto() {
        println("Scatto con lo smartphone")
    }
}

interface Camera {
    fun takePhoto() {
        println("Scatto con la fotocamera")
    }
}

// Classe che implementa le interfacce e risolve esplicitamente il conflitto tra i metodi di default
class IPhone : Smartphone, Camera {
    override fun takePhoto() {
        // Kotlin richiede di specificare quale implementazione usare
        super<Smartphone>.takePhoto()
        super<Camera>.takePhoto()
    }
}

// Modello usato con apply
class Car {
    var brand: String = ""
    var model: String = ""
}

// Funzione di ordine superiore che prende due numeri e una lambda che definisce l'operazione
fun operazioneSuNumeri(
    a: Int,
    b: Int,
    operazione: (Int, Int) -> Int
): Int = operazione(a, b)

fun main() {
    val phone = IPhone()
    phone.takePhoto()

    println()
    // Scope function: apply, serve per configurare un oggetto appena creato senza ripetere il nome della variabile
    val car = Car().apply {
        brand = "Toyota"
        model = "Yaris"
    }

    println("Auto creata: ${car.brand} ${car.model}")

    println()

    // Scope function: let esegue il blocco solo se la variabile non è null
    val nullableString: String? = "kotlin"
    nullableString?.let {
        println("Stringa in maiuscolo: ${it.uppercase()}")
    }

    println()
    // Funzione di ordine superiore con trailing lambda
    val risultato = operazioneSuNumeri(4, 5) { x, y ->
        x * y
    }

    println("Risultato moltiplicazione: $risultato")

    println()

    // filter con lambda implicita e "it"
    val voti = listOf(18, 25, 30, 15)
    val votiSufficienti = voti.filter { it >= 18 }

    println("Voti sufficienti: $votiSufficienti")
}