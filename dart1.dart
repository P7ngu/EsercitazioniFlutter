import 'dart:math';
import 'dart:io';

void main() {
  //Istanzia un generatore di numeri casuali
  final random = Random(); 

  //Genera un numero casuale tra 1 e 100
  final int numeroCasuale = random.nextInt(100) + 1; 

  print("Indovina il numero tra 1 e 100!");

  //Ciclo infinito finché l'utente non indovina il numero
  while (true) {
    print("\nInserisci un numero:");

    //Legge l'input dell'utente
    String? input = stdin.readLineSync(); 

    //Tenta di convertire l'input in un numero intero
    int? numeroUtente = int.tryParse(input ?? ""); 

    //Controlla se la conversione è fallita
    if (numeroUtente == null) { 
      print("Inserisci un numero valido!");
      continue;
    }

    //Controlla se il numero è fuori dal range
    if(numeroUtente < 1 || numeroUtente > 100) { 
      print("Il numero deve essere tra 1 e 100!");
      continue;
    }

    if (numeroUtente > numeroCasuale) {
      print("Troppo alto!");
    } else if (numeroUtente < numeroCasuale) {
      print("Troppo basso!");
    } else {
      print("🎉 Complimenti! Hai indovinato!");
      break;
    }
  }
}