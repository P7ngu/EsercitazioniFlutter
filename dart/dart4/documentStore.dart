//REPO documenti (simulazione di un database in memoria)
import 'document.dart';

// La classe DocumentStore funge da "repository" o "database" in memoria per i documenti (fatture, ordini, preventivi, ecc).
// Permette di aggiungere, rimuovere, cercare documenti per id, e calcolare il totale complessivo di tutti i documenti memorizzati. 
class DocumentStore {
  final List<Document> _docs = [];

  List<Document> get documents => List.unmodifiable(_docs);

  void add(Document doc) => _docs.add(doc);

  bool removeById(String id) {
    final idx = _docs.indexWhere((d) => d.id == id);
    if (idx == -1) return false;
    _docs.removeAt(idx);
    return true;
  }

  Document? findById(String id) {
    for (final d in _docs) {
      if (d.id == id) return d;
    }
    return null;
  }

  double grandTotal() => _docs.fold(0.0, (sum, d) => sum + d.total());


}