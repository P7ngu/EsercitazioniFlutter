import 'automobile.dart';
import 'veicolo.dart';

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