/// Ordine: può avere una fee di spedizione (esempio) + sconti
// L'ordine è un documento che rappresenta una richiesta di acquisto da parte di un cliente. 
//Può includere una fee di spedizione, che rappresenta il costo aggiuntivo per la consegna dei prodotti al cliente. 
//Inoltre, l'ordine può supportare sconti, sia in percentuale che in importo fisso, per rendere l'offerta più competitiva e attrarre i clienti.

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