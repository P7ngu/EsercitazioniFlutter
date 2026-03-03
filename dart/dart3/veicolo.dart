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