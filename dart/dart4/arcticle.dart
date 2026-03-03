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