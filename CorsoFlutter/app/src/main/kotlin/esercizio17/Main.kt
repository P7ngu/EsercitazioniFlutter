package esercizio17

// Main
fun main() {
    val contatti = listOf(
        Contatto("Bruclino", 25),
        Contatto("Pippo", 30),
        Contatto("Minnie", 15)
    )

    val rubrica = RubricaManager(contatti)

    println("Maggiorenni: ${rubrica.ottieniMaggiorenni()}")
    println("Nomi in maiuscolo: ${rubrica.ottieniNomiMaiuscoli()}")
    println("Cerca 'pippo': ${rubrica.cercaPerNome("pippo")}")

    val nomiDuplicati = listOf("Anna", "Luca", "Anna", "Marco", "Luca")
    val nomiPuliti = rubrica.pulisciNomi(nomiDuplicati)
    println("Nomi senza duplicati: $nomiPuliti")
}
