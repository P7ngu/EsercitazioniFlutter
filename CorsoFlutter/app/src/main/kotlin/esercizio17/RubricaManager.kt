package esercizio17

// Business Logic
class RubricaManager(private val contatti: List<Contatto>) {
    fun ottieniMaggiorenni(): List<Contatto> =
        contatti.filter { it.eta >= 18 }

    fun ottieniNomiMaiuscoli(): List<String> =
        contatti.map { it.nome.uppercase() }

    fun cercaPerNome(nomeTarget: String): Contatto? =
        contatti.firstOrNull { it.nome.equals(nomeTarget, ignoreCase = true) }

    fun pulisciNomi(nomiGrezzi: List<String>): Set<String> =
        nomiGrezzi.toSet()
}
