
import 'document.dart';

mixin DiscountMixin on Document {
  //Qesto mixin aggiunge la possibilità di gestire sconti sia in importo fisso che in percentuale, a tutti i document
  //Dentro posso quindi usare tutti i campi e metodi di Document, ad esempio per calcolare il totale con sconto, o per mostrare le info sugli sconti
  //Usiamo il mixing per creare combo di funzionalità, ad esempio potremmo avere un Documento che è anche scontabile, oppure un altro che non lo è, senza dover creare una gerarchia complessa di classi
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
