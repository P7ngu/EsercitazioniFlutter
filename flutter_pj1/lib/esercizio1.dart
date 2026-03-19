import 'package:flutter/material.dart';

class Esercizio1Page extends StatefulWidget {
  const Esercizio1Page({super.key});

  @override
  State<Esercizio1Page> createState() => _Esercizio1PageState();
}

class _Esercizio1PageState extends State<Esercizio1Page> {
  bool _switchOn = false;
  bool _showMessage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Esercizio 1'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/esercizio1.png',
                height: 180,
              ),
              const SizedBox(height: 16),
              Switch(
                value: _switchOn,
                onChanged: (value) {
                  setState(() {
                    _switchOn = value;
                  });
                },
              ),
              Text(
                _switchOn ? 'Lo switch è acceso' : 'Lo switch è spento',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),
              if (_showMessage)
                const Text(
                  'Messaggio mostrato!',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _showMessage = true;
                      });
                    },
                    child: const Text('Mostra messaggio'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _showMessage = false;
                      });
                    },
                    child: const Text('Nascondi messaggio'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
