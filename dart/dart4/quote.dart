/// Preventivo: solo stima, niente IVA, supporta sconti
/// 
import 'document.dart';
import 'discountMixin.dart';
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