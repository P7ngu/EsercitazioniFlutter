import 'document.dart';
import 'discountMixin.dart';

// Fattura: applica IVA (22% di default) + supporta sconti (percentuale o fisso)
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
