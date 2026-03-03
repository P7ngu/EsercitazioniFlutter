/// Ordine: può avere una fee di spedizione (esempio) + sconti
/// 

import 'document.dart';
import 'discountMixin.dart';
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