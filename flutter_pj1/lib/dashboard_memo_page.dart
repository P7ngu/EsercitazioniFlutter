import 'package:flutter/material.dart';

class DashboardMemoPage extends StatelessWidget {
  const DashboardMemoPage({super.key});

  static const Color _totaliColor = Color(0xFFBBDEFB);
  static const Color _completatiColor = Color(0xFFC8E6C9);
  static const Color _urgentiColor = Color(0xFFFFCDD2);
  static const Color _tableHeaderColor = Color(0xFFE0E0E0);
  static const Color _tableBorderColor = Color(0xFFBDBDBD);
  static const Color _notePanelColor = Color(0xFFFFF9C4);

  static const List<_MemoRow> _memoRows = [
    _MemoRow(
      title: 'Preparare presentazione',
      date: 'Oggi',
      priority: 'Urgente',
      color: Color(0xFFFFCDD2),
    ),
    _MemoRow(
      title: 'Spesa settimanale',
      date: 'Domani',
      priority: 'Normale',
      color: Color(0xFFF5F5F5),
    ),
    _MemoRow(
      title: 'Chiamare Marco',
      date: 'Oggi',
      priority: 'Normale',
      color: Color(0xFFC8E6C9),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final EdgeInsets padding = EdgeInsets.all(size.width * 0.04);
    final bool isLandscape = size.width > size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Memo'),
      ),
      body: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Barra statistiche.
            buildStatsRow(),
            const SizedBox(height: 20),
            // Contenuto principale e pannello laterale.
            Expanded(
              child: _buildContentGrid(context, isLandscape),
            ),
          ],
        ),
      ),
    );
  }

  // Card statistica riutilizzabile.
  Widget statCard(String label, String value, Color bgColor) {
    return Container(
      width: 110,
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // Riga statistiche.
  Widget buildStatsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        statCard('Totali', '24', _totaliColor),
        statCard('Completati', '12', _completatiColor),
        statCard('Urgenti', '3', _urgentiColor),
      ],
    );
  }

  // Grid responsive: stacked in portrait, affiancato in landscape.
  Widget _buildContentGrid(BuildContext context, bool isLandscape) {
    return GridView.count(
      crossAxisCount: isLandscape ? 2 : 1,
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      childAspectRatio: isLandscape ? 1.6 : 1.25,
      children: [
        _buildTableArea(context),
        _buildSidePanel(context),
      ],
    );
  }

  // Area tabella con dati principali.
  Widget _buildTableArea(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _tableBorderColor),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTableHeader(),
          const SizedBox(height: 8),
          for (final _MemoRow row in _memoRows) _buildTableRow(row),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      decoration: BoxDecoration(
        color: _tableHeaderColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _tableBorderColor),
      ),
      child: Row(
        children: [
          _buildTableCell('Titolo', flex: 2, isHeader: true),
          _buildTableCell('Data', isHeader: true),
          _buildTableCell('Priorità', isHeader: true),
        ],
      ),
    );
  }

  Widget _buildTableRow(_MemoRow row) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: row.color,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _tableBorderColor),
      ),
      child: Row(
        children: [
          _buildTableCell(row.title, flex: 2),
          _buildTableCell(row.date),
          _buildTableCell(row.priority),
        ],
      ),
    );
  }

  Widget _buildTableCell(
    String text, {
    int flex = 1,
    bool isHeader = false,
  }) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Text(
          text,
          style: TextStyle(
            fontSize: isHeader ? 13 : 12,
            fontWeight: isHeader ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  // Pannello laterale con note rapide.
  Widget _buildSidePanel(BuildContext context) {
    final TextStyle? titleStyle = Theme.of(context)
        .textTheme
        .titleMedium
        ?.copyWith(fontWeight: FontWeight.bold);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _notePanelColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _tableBorderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Note rapide', style: titleStyle),
          const SizedBox(height: 12),
          _buildBullet('Ricordarsi di inviare email a Giulia'),
          const SizedBox(height: 8),
          _buildBullet('Aggiornare la lista dei progetti'),
          const SizedBox(height: 8),
          _buildBullet('Preparare budget trimestrale'),
        ],
      ),
    );
  }

  Widget _buildBullet(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('• '),
        Expanded(child: Text(text)),
      ],
    );
  }
}

class _MemoRow {
  const _MemoRow({
    required this.title,
    required this.date,
    required this.priority,
    required this.color,
  });

  final String title;
  final String date;
  final String priority;
  final Color color;
}
