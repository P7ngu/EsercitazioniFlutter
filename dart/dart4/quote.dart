/// Preventivo: solo stima, niente IVA, supporta sconti
// Il preventivo è un documento che serve a fornire al cliente una stima dei costi di un servizio o prodotto, senza includere l'IVA.
// Può essere usato per dare al cliente un'idea del prezzo prima di emettere una fattura vera e propria. Il preventivo può includere sconti,
// sia in percentuale che in importo fisso, per rendere l'offerta più attraente.
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