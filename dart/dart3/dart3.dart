
class Veicolo {
  // Uso "final" => il valore si assegna solo nel costruttore e poi non cambia più.
  final String _marca;
  final String _modello;
  final int _anno;

  // 1 variabile statica. È condivisa tra tutte le istanze della classe.
  static int _numeroVeicoliCreati = 0;

  // Costruttore: inizializza le proprietà final
  Veicolo(this._marca, this._modello, this._anno) {
    // Ogni volta che creo un oggetto Veicolo (o sottoclasse), incremento il contatore.
    _numeroVeicoliCreati++;
  }

  // Incapsulamento: campi privati, ma accesso in lettura tramite getter.
  String get marca => _marca;
  String get modello => _modello;
  int get anno => _anno;

  // Metodi che agiscono sul singolo oggetto (istanza).
  void accelera() {
    print("[$runtimeType] $marca $modello sta accelerando.");
  }

  void decelera() {
    print("[$runtimeType] $marca $modello sta decelerando.");
  }

  // Questo metodo verrà ridefinito nella sottoclasse Automobile.
  void descrizione() {
    print("Veicolo: $marca $modello ($anno)");
  }

  // metodo static
  // Si invoca con Veicolo.mostraNumeroVeicoli(), non su un'istanza.
  static void mostraNumeroVeicoli() {
    print("Totale veicoli creati: $_numeroVeicoliCreati");
  }
}


//Definiamo una sottoclasse di Veicolo, chiamata Automobile, che eredita tutte le proprietà e i metodi di Veicolo, ma aggiunge anche nuove funzionalità specifiche per le automobili.

class Automobile extends Veicolo {
  // Ha 3 proprietà private, di cui 2 NON modificabili dopo inizializzazione ---
  final int _numeroPorte;          // non modificabile
  final String _tipoCarburante;    // non modificabile
  String _colore;                  // modificabile

  // Costruttore: inizializzo i campi della sottoclasse + chiamo il costruttore padre con super
  Automobile(
    String marca,
    String modello,
    int anno,
    this._numeroPorte,
    this._tipoCarburante,
    this._colore,
  ) : super(marca, modello, anno);

  // Getter pubblici
  int get numeroPorte => _numeroPorte;
  String get tipoCarburante => _tipoCarburante;
  String get colore => _colore;

  // Setter (solo per la proprietà modificabile, gli altri sono final e non hanno setter)
  set colore(String nuovoColore) {
    _colore = nuovoColore;
  }

  // metodi di istanza della sottoclasse
  void apriBagagliaio() {
    print("[$runtimeType] $marca $modello: Bagagliaio aperto.");
  }

  void suonaClacson() {
    print("[$runtimeType] $marca $modello: BEEP BEEP!");
  }

  // Override del metodo della classe padre
  @override
  void descrizione() {
    // Qui “sovrascrivo” il comportamento del metodo definito in Veicolo.
    print(
      "Automobile: $marca $modello ($anno), "
      "$numeroPorte porte, carburante: $tipoCarburante, colore: $colore"
    );
  }

  //1 metodo static
  static void infoCategoria() {
    print("Le automobili sono veicoli a motore per trasporto privato.");
  }
}

void main() {
  // Creo un Veicolo
  final veicolo = Veicolo("Yamaha", "MT-07", 2022);
  veicolo.accelera();
  veicolo.decelera();
  veicolo.descrizione();

  print("\n----------------\n");

  // Creo un'Automobile
  final auto = Automobile("Toyota", "Yaris", 2023, 5, "Benzina", "Rosso");
  auto.accelera();        // ereditato da Veicolo
  auto.apriBagagliaio();  // metodo specifico di Automobile
  auto.suonaClacson();    // metodo specifico di Automobile

  // set colore usando il setter
  auto.colore = "Blu";
  auto.descrizione();     // versione override (Automobile)

  print("\n----------------\n");

  // uso gli static, senza istanza
  Veicolo.mostraNumeroVeicoli(); // statico: non richiede istanza
  Automobile.infoCategoria();    // statico della sottoclasse

  print("\n----------------\n");

  // Il metodo chiamato viene scelto a runtime (dynamic dispatch).

  final List<Veicolo> garage = [
    Veicolo("Piaggio", "Liberty", 2020),
    Automobile("Fiat", "Panda", 2018, 5, "GPL", "Bianco"),
    Automobile("Tesla", "Model 3", 2021, 4, "Elettrico", "Nero"),
  ];

  // Qui chiamo descrizione() su ogni elemento, per verificare che sia chiamato il metodo corretto (Veicolo o Automobile) grazie al dynamic dispatch.
  for (final v in garage) {
    v.descrizione();
  }

  print("\n----------------\n");

  // Contatore statico aggiornato (include tutte le istanze create)
  Veicolo.mostraNumeroVeicoli();

}