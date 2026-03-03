
import 'payable.dart';
import 'arcticle.dart';
// Documento base, con funzionalità comuni a tutti i tipi di documento (fattura, ordine, preventivo, ecc.)
abstract class Document implements Payable {
  final String _id;
  final DateTime _createdAt;
  final List<Article> _items = [];

  Document({required String id})
      : _id = id.trim(),
        _createdAt = DateTime.now() {
    if (_id.isEmpty) throw ArgumentError('id non può essere vuoto');
  }

  String get id => _id;
  DateTime get createdAt => _createdAt;

  // vista read-only (incapsulamento)
  List<Article> get items => List.unmodifiable(_items);

  void addArticle(Article article) {
    _items.add(article);
  }

  void removeArticleAt(int index) {
    if (index < 0 || index >= _items.length) {
      throw RangeError.index(index, _items, 'index');
    }
    _items.removeAt(index);
  }

  void clearArticles() => _items.clear();

  double subTotal() => _items.fold(0.0, (sum, a) => sum + a.lineTotal);

  /// Hook per logiche specifiche del tipo documento (tasse, fee, ecc.)
  double extraCharges() => 0.0;

  /// Totale base: subtotale + extra (poi eventualmente sconti / tasse nei figli)
  @override
  double total() => subTotal() + extraCharges();

  @override
  String toString() => '$runtimeType(id: $id, items: ${_items.length})';

  void printDetails() {
  print('Tipo documento : $runtimeType');
  print('ID             : $_id');
  print('Creato il      : $_createdAt');

  print('\nArticoli:');
  for (final item in _items) {
    print(
      '- ${item.name} | qty: ${item.quantity} | unit: ${item.unitPrice.toStringAsFixed(2)} | tot: ${item.lineTotal.toStringAsFixed(2)}',
    );
  }

  print('\nSubTotale      : ${subTotal().toStringAsFixed(2)}');
}
}