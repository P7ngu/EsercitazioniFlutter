import 'veicolo.dart';
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