import 'dart:io';
import 'dart:math';

const int maxLootbox = 10; // variabile globale: se voglio modificare in futuro, cambio solo qui, e si propaga ovunque

Future<void> main() async { // main diventa async per poter usare await al suo interno, ogni await interno bloccherà l'esecuzione di main finché non sarà completato, ma non bloccherà l'intero programma
  final random = Random();
  await runLootboxPokemon(random);
}

// runLootboxPokemon diventa async perché al suo interno chiama funzioni che usano await, e quindi deve essere async per poter usare await al suo interno
//Questa funzione è il cuore del programma, coordina tutte le altre funzioni per eseguire il flusso completo dell'apertura delle lootbox e della stampa dei risultati
Future<void> runLootboxPokemon(Random random) async {
  //Creo la mappa (pool) delle carte Pokémon, che contiene le categorie e le carte associate a ciascuna categoria
  final Map<String, List<String>> cartePokemon = creaPoolCartePokemon();

  // Stampo il titolo del programma
  stampaTitolo();

  //Chiede input all'utente su quante lootbox aprire, validando l'input per assicurarsi che sia un numero valido compreso tra 1 e maxLootbox
  final int numeroLootbox = chiediQuanteLootboxAprire();

  //Estrae i premi aprendo le lootbox, restituendo una lista di premi ottenuti (oggetto + categoria) che viene salvata in inventario
  final inventario = await estraiPremi(
    numeroLootbox: numeroLootbox,
    cartePokemon: cartePokemon,
    random: random,
  );

  //Crea un riepilogo dei premi ottenuti raggruppandoli per categoria, restituendo una mappa che associa ogni categoria alla lista di oggetti ottenuti in quella categoria
  final riepilogo = creaRiepilogo(inventario);

  //Stampa il riepilogo dei premi ottenuti, mostrando prima il riepilogo raggruppato per categoria e poi l'elenco completo dei premi ottenuti in ordine di apertura
  stampaOutputFinale(riepilogo, inventario);
}

/// Perché separare in funzioni piccole:
/// leggibilità (sopra è letteralmente un flowchart del programma, è facile capire cosa succede)
/// testabilità (posso testare ogni funzionalità separatamente)
/// estendibilità (aggiungere nuove rarità o UI diversa è più semplice)

// Crea la mappa (pool) delle carte
Map<String, List<String>> creaPoolCartePokemon() {
  return {
    "Comune": [
      "Carta Comune: Piplup",
      "Carta Comune: Pikachu",
    ],
    "Raro": [
      "Carta Rara: Gengar",
      "Carta Rara: Charizard",
    ],
    "Epico": [
      "Ultra Rara: Mega Charizard ex",
      "Illustrazione Speciale: Bubble Mew",
    ],
  };
}

void stampaTitolo() {
  print("=== LOOTBOX POKÉMON ===");
}

int chiediQuanteLootboxAprire() {
  return leggiNumeroLootboxDaAprire();
}

Future<List<Map<String, String>>> estraiPremi({
  required int numeroLootbox,
  required Map<String, List<String>> cartePokemon,
  required Random random,
}) async {
  return await apriLootboxMultiple(
    quante: numeroLootbox,
    premi: cartePokemon,
    random: random,
  );
}

Map<String, List<String>> creaRiepilogo(List<Map<String, String>> inventario) {
  return raggruppaPerCategoria(inventario);
}

void stampaOutputFinale(
  Map<String, List<String>> riepilogo,
  List<Map<String, String>> inventario,
) {
  stampaRiepilogo(riepilogo);
  stampaElencoCompleto(inventario);
  print("\nFine apertura!");
}

/// Legge da console quante lootbox aprire, validando input (1..max)
int leggiNumeroLootboxDaAprire() {
  while (true) {
    print("Quante lootbox Pokémon vuoi aprire? (1-$maxLootbox)");
    final String? input = stdin.readLineSync();

    final int? valore = int.tryParse((input ?? "").trim());

    if (valore == null) {
      print("Inserisci un numero valido.\n");
      continue;
    }

    if (valore < 1 || valore > maxLootbox) {
      print("Non valido. Puoi aprire da 1 a $maxLootbox lootbox.\n");
      continue;
    }

    return valore;
  }
}

/// Apre N lootbox e restituisce l'inventario come lista di premi ottenuti (oggetto + categoria)
/// Perché Future + delay: simuliamo “suspense” come in un gioco (UX in console)
Future<List<Map<String, String>>> apriLootboxMultiple({
  required int quante,
  required Map<String, List<String>> premi,
  required Random random,
}) async {
  final List<Map<String, String>> inventario = [];
  final List<String> categorie = premi.keys.toList();

  print("\n🔓 Apertura lootbox...\n");

  for (int i = 1; i <= quante; i++) {
    // Simulazione suspense
    print("Apro lo scrigno $i...");
    await Future.delayed(const Duration(seconds: 1));

    final premio = estraiPremio(premi: premi, categorie: categorie, random: random);
    inventario.add(premio);

    print("✨ Trovato: ${premio["oggetto"]} (${premio["categoria"]})");
    await Future.delayed(const Duration(milliseconds: 800));

    print("----------------------------");
    await Future.delayed(const Duration(milliseconds: 400));
  }

  return inventario;
}

/// Estrae un singolo premio casuale scegliendo prima una categoria e poi un oggetto all'interno di quella categoria
Map<String, String> estraiPremio({
  required Map<String, List<String>> premi,
  required List<String> categorie,
  required Random random,
}) {
  final String categoria = categorie[random.nextInt(categorie.length)];

  final List<String> oggetti = premi[categoria]!;
  final String oggetto = oggetti[random.nextInt(oggetti.length)];

  return {"categoria": categoria, "oggetto": oggetto};
}

/// Raggruppa l'inventario per categoria, restituendo una mappa:
/// Perché farlo in una funzione: stampa e logica business restano separate
Map<String, List<String>> raggruppaPerCategoria(List<Map<String, String>> inventario) {
  final Map<String, List<String>> riepilogo = {
    "Comune": [],
    "Raro": [],
    "Epico": [],
  };

  for (final premio in inventario) {
    final String categoria = premio["categoria"]!;
    final String oggetto = premio["oggetto"]!;
    riepilogo.putIfAbsent(categoria, () => []);
    riepilogo[categoria]!.add(oggetto);
  }

  return riepilogo;
}

/// Stampa il riepilogo raggruppato per categoria
void stampaRiepilogo(Map<String, List<String>> riepilogo) {
  print("\n=== RIEPILOGO PREMI (divisi per rarità) ===");

  for (final categoria in riepilogo.keys) {
    print("\n$categoria:");
    final lista = riepilogo[categoria]!;

    if (lista.isEmpty) {
      print("Niente :(");
    } else {
      for (final oggetto in lista) {
        print("  - $oggetto");
      }
    }
  }
}

/// Stampa l'elenco completo dei premi ottenuti (in ordine di apertura)
void stampaElencoCompleto(List<Map<String, String>> inventario) {
  print("\nElenco completo premi ottenuti:");
  for (final premio in inventario) {
    print("- ${premio["oggetto"]} (${premio["categoria"]})");
  }
}