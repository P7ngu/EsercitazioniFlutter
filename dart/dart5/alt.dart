import 'dart:async';

/// Enum che rappresenta la categoria generale di un oggetto.
///
/// enum per classificare gli item
enum ItemCategory {
  attack,
  special,
  defense,
  utility;

  /// Metodo richiesto dalla traccia:
  /// permette di capire se un oggetto appartiene a una categoria offensiva.
  ///
  /// In questo caso consideriamo offensivi gli strumenti che aumentano
  /// attacco fisico o attacco speciale.
  bool isOffensive() {
    return this == ItemCategory.attack || this == ItemCategory.special;
  }
}

/// Piccolo enum aggiuntivo per rendere il tema più coerente con Pokémon.
///
/// Non è strettamente richiesto dalla traccia, ma rende il modello più chiaro
/// e più vicino al dominio che vogliamo rappresentare.
enum PokemonType {
  fire,
  water,
  grass,
  electric,
  psychic,
  dragon,
  normal,
  fighting,
  ghost,
}

/// Classe concreta che rappresenta le statistiche base del Pokémon.
///
/// La traccia richiede una classe concreta simile a HeroStats, con proprietà final.
/// Per rispettare pienamente il requisito, tutte le proprietà sono immutabili.
///
/// Quattro statistiche essenziali:
/// - attack
/// - specialAttack
/// - defense
/// - speed
///
/// In questo modo il modello rimane semplice ma comunque significativo nel contesto Pokémon.
/// L'uso di final garantisce che una volta create, le statistiche non possano essere modificate direttamente,
/// ma solo tramite la creazione di nuove istanze, coerentemente con il paradigma immutabile richiesto dalla traccia.
class PokemonStats {
  final int attack;
  final int specialAttack;
  final int defense;
  final int speed;

  const PokemonStats({
    required this.attack,
    required this.specialAttack,
    required this.defense,
    required this.speed,
  });

  /// Metodo di utilità molto importante in presenza di oggetti immutabili.
  ///
  /// Poiché i campi sono final, non possiamo modificare direttamente
  /// un'istanza esistente. Per aggiornare una o più statistiche,
  /// creiamo un nuovo oggetto PokemonStats con i valori desiderati.
  PokemonStats copyWith({
    int? attack,
    int? specialAttack,
    int? defense,
    int? speed,
  }) {
    return PokemonStats(
      attack: attack ?? this.attack,
      specialAttack: specialAttack ?? this.specialAttack,
      defense: defense ?? this.defense,
      speed: speed ?? this.speed,
    );
  }

  @override
  String toString() {
    return 'atk:$attack, spAtk:$specialAttack, def:$defense, spd:$speed';
  }
}

/// Classe astratta che rappresenta un generico strumento equipaggiabile.
///
/// Nella traccia viene richiesta una classe astratta Item con:
/// - un getter name
/// - un metodo applyTo(...)
/// applyTo riceve le statistiche base e restituisce nuove statistiche modificate
/// in base al bonus fornito dallo strumento.
abstract class Item {
  String get name;
  ItemCategory get category;

  PokemonStats applyTo(PokemonStats stats);
}

/// Classe concreta che rappresenta uno strumento offensivo fisico.
///
/// Equivale all'idea di "Weapon" nella traccia originale.
/// Qui il bonus viene applicato all'attacco fisico.
class AttackItem extends Item {
  final String _name;
  final int bonusAttack;

  AttackItem(this._name, this.bonusAttack);

  @override
  String get name => _name;

  @override
  ItemCategory get category => ItemCategory.attack;

  @override
  PokemonStats applyTo(PokemonStats stats) {
    return stats.copyWith(
      attack: stats.attack + bonusAttack,
    );
  }

  @override
  String toString() {
    return '$name (+$bonusAttack atk)';
  }
}

/// Classe concreta che rappresenta uno strumento per l'attacco speciale.
///
/// Nella traccia esiste un oggetto simile chiamato MagicArtifact.
/// In versione Pokémon ha molto senso tradurlo come strumento che aumenta
/// la statistica specialAttack.
class SpecialItem extends Item {
  final String _name;
  final int bonusSpecialAttack;

  SpecialItem(this._name, this.bonusSpecialAttack);

  @override
  String get name => _name;

  @override
  ItemCategory get category => ItemCategory.special;

  @override
  PokemonStats applyTo(PokemonStats stats) {
    return stats.copyWith(
      specialAttack: stats.specialAttack + bonusSpecialAttack,
    );
  }

  @override
  String toString() {
    return '$name (+$bonusSpecialAttack spAtk)';
  }
}

/// Classe concreta che rappresenta un oggetto difensivo.
///
/// Equivale alla classe DefensiveItem della traccia.
/// Aumenta la difesa in modo semplice e leggibile.
class DefensiveItem extends Item {
  final String _name;
  final int bonusDefense;

  DefensiveItem(this._name, this.bonusDefense);

  @override
  String get name => _name;

  @override
  ItemCategory get category => ItemCategory.defense;

  @override
  PokemonStats applyTo(PokemonStats stats) {
    return stats.copyWith(
      defense: stats.defense + bonusDefense,
    );
  }

  @override
  String toString() {
    return '$name (+$bonusDefense def)';
  }
}

/// Classe concreta che rappresenta un oggetto di utilità.
///
/// La traccia non impone per forza un bonus alla velocità, ma questa scelta
/// è coerente con la categoria Utility e arricchisce l'esempio.
class UtilityItem extends Item {
  final String _name;
  final int bonusSpeed;

  UtilityItem(this._name, this.bonusSpeed);

  @override
  String get name => _name;

  @override
  ItemCategory get category => ItemCategory.utility;

  @override
  PokemonStats applyTo(PokemonStats stats) {
    return stats.copyWith(
      speed: stats.speed + bonusSpeed,
    );
  }

  @override
  String toString() {
    return '$name (+$bonusSpeed spd)';
  }
}

/// Classe che rappresenta un Pokémon.
///
/// Non è esplicitamente richiesta dalla traccia, ma è utile per contestualizzare
/// meglio il sistema. Le statistiche vere e proprie restano comunque incapsulate
/// nella classe PokemonStats, che è il cuore del modello richiesto.
class Pokemon {
  final String name;
  final PokemonType type;
  final PokemonStats baseStats;

  const Pokemon({
    required this.name,
    required this.type,
    required this.baseStats,
  });

  @override
  String toString() {
    return '$name (${type.name})';
  }
}

/// Classe concreta che rappresenta la build completa del Pokémon.
///
/// La traccia richiede una classe Build che:
/// - contenga una lista di oggetti
/// - permetta di aggiungere item
/// - applichi gli effetti alle statistiche base
/// - calcoli un danno finale
///
/// Ho mantenuto un massimo di 6 oggetti, coerente sia con la traccia
/// sia con il numero simbolico molto ricorrente nel mondo Pokémon.
class Build {
  final List<Item> _items = [];

  /// Espongo una vista non modificabile della lista, così dall'esterno
  /// si può leggere il contenuto della build senza alterarlo direttamente.
  List<Item> get items => List.unmodifiable(_items);

  /// Aggiunge un oggetto alla build.
  ///
  /// Se si supera il limite massimo, viene lanciata un'eccezione.
  /// Questo serve a far rispettare il vincolo strutturale della build.
  void addItem(Item item) {
    if (_items.length >= 6) {
      throw Exception('La build può contenere al massimo 6 oggetti.');
    }
    _items.add(item);
  }

  /// Applica in sequenza tutti gli oggetti alle statistiche base.
  ///
  /// Notare che, poiché PokemonStats è immutabile, ogni applicazione
  /// produce un nuovo oggetto stats.
  PokemonStats applyTo(PokemonStats baseStats) {
    PokemonStats currentStats = baseStats;

    for (final item in _items) {
      currentStats = item.applyTo(currentStats);
    }

    return currentStats;
  }

  /// Calcolo semplice del danno finale.
  ///
  /// La traccia suggerisce una formula basilare del tipo:
  /// attacco + potere magico / 2
  ///
  /// Qui la adatto alle nostre statistiche Pokémon:
  /// damage = attack + specialAttack / 2
  ///
  /// Uso ~/ per ottenere una divisione intera.
  int calculateDamage(PokemonStats finalStats) {
    return finalStats.attack + (finalStats.specialAttack ~/ 2);
  }

  /// Metodo asincrono richiesto nella quarta fase della traccia.
  ///
  /// Riceve una lista di ID, usa l'ItemLoader per caricare gli oggetti
  /// in parallelo tramite Future.wait, e poi li aggiunge alla build.
  Future<void> loadItemsAsync(List<String> ids, ItemLoader loader) async {
    final List<Item> loadedItems = await Future.wait(
      ids.map((id) => loader.load(id)),
    );

    for (final item in loadedItems) {
      addItem(item);
    }
  }
}

/// Classe astratta per il caricamento di un oggetto a partire da un ID.
///
/// Corrisponde esattamente all'idea della traccia:
/// definire un'interfaccia astratta con un metodo Future<Item> load(String id).
abstract class ItemLoader {
  Future<Item> load(String id);
}

/// Classe concreta che simula un caricamento remoto.
///
/// La traccia richiede una chiamata remota simulata tramite Future.delayed.
/// Qui implemento proprio questo comportamento.
///
/// In base all'ID ricevuto, il loader restituisce un oggetto costruito
/// usando direttamente il costruttore della relativa classe concreta.
class RemoteItemLoader extends ItemLoader {
  @override
  Future<Item> load(String id) async {
    // Simulazione di latenza di rete.
    await Future.delayed(const Duration(milliseconds: 800));

    switch (id) {
      case 'attack_1':
        return AttackItem('Choice Band', 12);

      case 'attack_2':
        return AttackItem('Life Orb', 9);

      case 'special_1':
        return SpecialItem('Twisted Spoon', 10);

      case 'special_2':
        return SpecialItem('Wise Glasses', 8);

      case 'defense_1':
        return DefensiveItem('Rocky Helmet', 11);

      case 'defense_2':
        return DefensiveItem('Eviolite', 13);

      case 'utility_1':
        return UtilityItem('Quick Claw', 6);

      case 'utility_2':
        return UtilityItem('Choice Scarf', 12);

      default:
        throw Exception('Oggetto con id "$id" non trovato.');
    }
  }
}

/// Funzione di supporto per stampare una separazione leggibile nell'output.
///
/// Non è necessaria dal punto di vista algoritmico, ma migliora
/// la leggibilità dell'esecuzione finale.
void printDivider() {
  print('--------------------------------------------------');
}

/// Funzione che stampa una breve analisi della build caricata.
///
/// Questo passaggio non è richiesto strettamente dalla traccia,
/// ma aiuta a mostrare in modo chiaro il contenuto del sistema.
void printBuildSummary(Build build) {
  print('Oggetti presenti nella build:');

  for (int i = 0; i < build.items.length; i++) {
    final item = build.items[i];
    print(
      '- Slot ${i + 1}: ${item.name} | '
      'categoria: ${item.category.name} | '
      'offensivo: ${item.category.isOffensive()}',
    );
  }
}

/// Punto di ingresso del programma.
///
/// L'esecuzione mostra:
/// 1. creazione di un Pokémon con statistiche base
/// 2. caricamento asincrono di alcuni oggetti
/// 3. costruzione della build
/// 4. applicazione dei bonus alle statistiche
/// 5. calcolo del danno finale
Future<void> main() async {
  // Creo un Pokémon di esempio.
  // Ho scelto Pikachu perché è riconoscibile e ha senso modellarlo
  // come creatura veloce e orientata all'attacco speciale.
  final pikachu = Pokemon(
    name: 'Pikachu',
    type: PokemonType.electric,
    baseStats: const PokemonStats(
      attack: 14,
      specialAttack: 18,
      defense: 8,
      speed: 20,
    ),
  );

  // Creo la build vuota e il loader remoto.
  final build = Build();
  final loader = RemoteItemLoader();

  printDivider();
  print('POKÉMON SELEZIONATO');
  print('Nome: ${pikachu.name}');
  print('Tipo: ${pikachu.type.name}');
  print('Statistiche base: ${pikachu.baseStats}');
  printDivider();

  // Lista di ID che identificano gli oggetti da caricare.
  // Il caricamento avviene in parallelo grazie a Future.wait.
  final itemIds = <String>[
    'attack_1',
    'special_1',
    'defense_1',
    'utility_2',
  ];

  print('Caricamento asincrono degli strumenti in corso...');
  await build.loadItemsAsync(itemIds, loader);
  print('Caricamento completato.');
  printDivider();

  printBuildSummary(build);
  printDivider();

  // Applico tutti gli item alle statistiche base del Pokémon.
  final finalStats = build.applyTo(pikachu.baseStats);

  // Calcolo il danno usando le statistiche finali.
  final finalDamage = build.calculateDamage(finalStats);

  print('RISULTATO FINALE');
  print('Statistiche iniziali: ${pikachu.baseStats}');
  print('Statistiche finali:   $finalStats');
  print('Danno finale calcolato: $finalDamage');
  printDivider();
}