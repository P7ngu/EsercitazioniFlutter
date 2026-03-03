
// Interfaccia Payable
abstract interface class Payable {
  double total();
}

//Articolo generico da vendere, con nome, prezzo unitario e quantità
class Article {
  final String _name;
  final double _unitPrice;
  final int _quantity;

  Article({
    required String name,
    required double unitPrice,
    required int quantity,
  })  : _name = name.trim(),
        _unitPrice = unitPrice,
        _quantity = quantity {
    if (_name.isEmpty) throw ArgumentError('name non può essere vuoto');
    if (_unitPrice < 0) throw ArgumentError('unitPrice non può essere negativo');
    if (_quantity <= 0) throw ArgumentError('quantity deve essere > 0');
  }

  String get name => _name;
  double get unitPrice => _unitPrice;
  int get quantity => _quantity;

  double get lineTotal => _unitPrice * _quantity;

  @override
  String toString() => '$_name x$_quantity @ ${_unitPrice.toStringAsFixed(2)}';
}


mixin DiscountMixin on Document {
  double _discountAmount = 0.0; // sconto fisso in €
  double _discountPercent = 0.0; // sconto percentuale 0..100

  double get discountAmount => _discountAmount;
  double get discountPercent => _discountPercent;

  void setDiscountAmount(double amount) {
    if (amount < 0) throw ArgumentError('discountAmount non può essere negativo');
    _discountAmount = amount;
  }

  void setDiscountPercent(double percent) {
    if (percent < 0 || percent > 100) {
      throw ArgumentError('discountPercent deve essere tra 0 e 100');
    }
    _discountPercent = percent;
  }

  void clearDiscounts() {
    _discountAmount = 0.0;
    _discountPercent = 0.0;
  }

  /// Applica gli sconti al subtotale del documento (senza tasse)
  double applyDiscounts(double subTotal) {
    var result = subTotal;

    // Percentuale prima, poi importo fisso (esempio di logica, può essere diversa a seconda del business)
    if (_discountPercent > 0) {
      result = result * (1 - _discountPercent / 100.0);
    }

    if (_discountAmount > 0) {
      result = result - _discountAmount;
    }

    // Mai sotto zero
    return result < 0 ? 0 : result;
  }
}

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


/// Fattura: applica IVA (22% di default) + supporta sconti (percentuale o fisso)
class Invoice extends Document with DiscountMixin {
  final double _vatPercent; // es. 22

  Invoice({required super.id, double vatPercent = 22.0})
      : _vatPercent = vatPercent {
    if (_vatPercent < 0 || _vatPercent > 100) {
      throw ArgumentError('vatPercent deve essere tra 0 e 100');
    }
  }

  double get vatPercent => _vatPercent;

  double vatAmount(double taxable) => taxable * (_vatPercent / 100.0);

  @override
  double total() {
    final sub = subTotal();
    final discounted = applyDiscounts(sub);
    final vat = vatAmount(discounted);
    return discounted + vat;
  }

  @override
void printDetails() {
  super.printDetails();

  final discounted = applyDiscounts(subTotal());
  final vat = discounted * (_vatPercent / 100);

  print('Sconto %       : $discountPercent');
  print('Sconto €       : $discountAmount');
  print('IVA %          : $_vatPercent');
  print('IVA €          : ${vat.toStringAsFixed(2)}');
  print('TOTALE         : ${total().toStringAsFixed(2)}');
  print('-----\n');
}
}

/// Ordine: può avere una fee di spedizione (esempio) + sconti
class OrderDoc extends Document with DiscountMixin {
  double _shippingFee = 0.0;

  OrderDoc({required super.id});

  double get shippingFee => _shippingFee;

  void setShippingFee(double fee) {
    if (fee < 0) throw ArgumentError('shippingFee non può essere negativa');
    _shippingFee = fee;
  }

  @override
  double total() {
    final sub = subTotal();
    final discounted = applyDiscounts(sub);
    return discounted + _shippingFee;
  }

  @override
void printDetails() {
  super.printDetails();

  print('Sconto %       : $discountPercent');
  print('Sconto €       : $discountAmount');
  print('Spedizione €   : ${_shippingFee.toStringAsFixed(2)}');
  print('TOTALE         : ${total().toStringAsFixed(2)}');
  print('---\n');
}
}

/// Preventivo: solo stima, niente IVA, supporta sconti
class Quote extends Document with DiscountMixin {
  Quote({required super.id});

  @override
  double total() {
    final sub = subTotal();
    return applyDiscounts(sub);
  }

  @override
void printDetails() {
  super.printDetails();

  print('Sconto %       : $discountPercent');
  print('Sconto €       : $discountAmount');
  print('TOTALE STIMATO : ${total().toStringAsFixed(2)}');
  print('---\n');
}
}

//REPO documenti (simulazione di un database in memoria)
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

//Main di test
void main() {
  final store = DocumentStore();

  final invoice = Invoice(id: 'FAT-001', vatPercent: 22);
  invoice.addArticle(Article(name: 'Sviluppo Flutter', unitPrice: 60, quantity: 10));
  invoice.addArticle(Article(name: 'UI/UX Review', unitPrice: 80, quantity: 2));
  invoice.setDiscountPercent(10); // -10% sul subtotale prima IVA
  store.add(invoice);

  final order = OrderDoc(id: 'ORD-100');
  order.addArticle(Article(name: 'ETB', unitPrice: 49.99, quantity: 1));
  order.addArticle(Article(name: 'Sleeves', unitPrice: 7.50, quantity: 2));
  order.setShippingFee(5.90);
  order.setDiscountAmount(3.00); // -3€ fisso
  store.add(order);

  final quote = Quote(id: 'PREV-77');
  quote.addArticle(Article(name: 'App MVP', unitPrice: 1200, quantity: 1));
  quote.setDiscountPercent(5);
  store.add(quote);

  for (final d in store.documents) {
    print('${d.runtimeType} ${d.id} -> totale: ${d.total().toStringAsFixed(2)}');
  }

  for (final d in store.documents) {
  d.printDetails();
  } 

  print('Totale complessivo: ${store.grandTotal().toStringAsFixed(2)}');
}