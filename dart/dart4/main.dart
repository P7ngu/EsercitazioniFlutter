import 'documentStore.dart';
import 'arcticle.dart';
import 'invoice.dart';

import 'order.dart';
import 'quote.dart';








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