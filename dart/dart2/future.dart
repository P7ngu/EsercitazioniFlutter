///Internamente:

//Viene registrato un timer

//La funzione si “mette in pausa”

//Il resto del programma può continuare

//Dopo 2 secondi, il Future si completa

//La funzione riprende da dove era stata sospesa

import 'dart:async';

void main() async {
  print("Inizio");

  await Future.delayed(Duration(seconds: 2));

  print("Fine");
}
