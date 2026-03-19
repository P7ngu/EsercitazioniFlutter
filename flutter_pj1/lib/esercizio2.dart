import 'dart:math';

import 'package:flutter/material.dart';

class UserProfile {
  const UserProfile({
    required this.name,
    required this.email,
    required this.role,
    this.isHighlighted = false,
  });

  final String name;
  final String email;
  final String role;
  final bool isHighlighted;

  UserProfile copyWith({bool? isHighlighted}) {
    return UserProfile(
      name: name,
      email: email,
      role: role,
      isHighlighted: isHighlighted ?? this.isHighlighted,
    );
  }
}

class UserCard extends StatelessWidget {
  const UserCard({super.key, required this.user});

  final UserProfile user;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final Color background =
        user.isHighlighted ? colors.primaryContainer : colors.surface;
    final Color borderColor =
        user.isHighlighted ? colors.primary : colors.outlineVariant;

    return Card(
      color: background,
      elevation: user.isHighlighted ? 3 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: borderColor, width: 1),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: colors.primary,
          foregroundColor: colors.onPrimary,
          child: Text(user.name.substring(0, 1).toUpperCase()),
        ),
        title: Text(user.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Tooltip(
              message: user.email,
              child: Text(user.email),
            ),
            const SizedBox(height: 4),
            Text(user.role),
          ],
        ),
        trailing: user.isHighlighted
            ? const Icon(Icons.star, color: Colors.orange)
            : const Icon(Icons.star_border),
      ),
    );
  }
}

class Esercizio2Page extends StatefulWidget {
  const Esercizio2Page({super.key});

  @override
  State<Esercizio2Page> createState() => _Esercizio2PageState();
}

class _Esercizio2PageState extends State<Esercizio2Page> {
  final Random _random = Random();
  final List<UserProfile> _users = [
    const UserProfile(
      name: 'Giulia Rossi',
      email: 'giulia.rossi@email.it',
      role: 'Designer',
    ),
    const UserProfile(
      name: 'Marco Bianchi',
      email: 'marco.bianchi@email.it',
      role: 'Developer',
    ),
    const UserProfile(
      name: 'Luca Neri',
      email: 'luca.neri@email.it',
      role: 'QA Engineer',
    ),
  ];

  void _highlightRandomUser() {
    if (_users.isEmpty) {
      return;
    }
    final int index = _random.nextInt(_users.length);
    setState(() {
      for (int i = 0; i < _users.length; i++) {
        _users[i] = _users[i].copyWith(isHighlighted: i == index);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Esercizio 2'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.separated(
          itemCount: _users.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            return UserCard(user: _users[index]);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _highlightRandomUser,
        icon: const Icon(Icons.auto_awesome),
        label: const Text('Evidenzia casuale'),
      ),
    );
  }
}
