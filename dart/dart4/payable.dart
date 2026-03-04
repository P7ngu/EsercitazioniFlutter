abstract interface class Payable {
  double total();
}

//Definisco un contratto per i documenti che possono essere pagati, con un metodo per calcolare il totale da pagare.
// L'interfaccia Payable definisce un contratto per i documenti che possono essere pagati, richiedendo l'implementazione del metodo total(), che calcola il totale da pagare per il documento.
// Questo permette di avere una struttura flessibile, dove diversi tipi di documenti (fatture, ordini, preventivi) 
//possono implementare Payable e fornire la propria logica per calcolare il totale, senza dover condividere una gerarchia di classi rigida.