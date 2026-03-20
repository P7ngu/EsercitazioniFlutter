import 'package:flutter/material.dart';
import 'theme_mode_toggle.dart';

enum _RowTone { urgent, neutral, success }

enum _StatType { totali, completati, urgenti }

class DashboardMemoPage extends StatelessWidget {
  const DashboardMemoPage({super.key});

  static const List<_MemoRow> _memoRows = [
    _MemoRow(
      title: 'Preparare presentazione',
      date: 'Oggi',
      priority: 'Urgente',
      tone: _RowTone.urgent,
    ),
    _MemoRow(
      title: 'Spesa settimanale',
      date: 'Domani',
      priority: 'Normale',
      tone: _RowTone.neutral,
    ),
    _MemoRow(
      title: 'Chiamare Marco',
      date: 'Oggi',
      priority: 'Normale',
      tone: _RowTone.success,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final EdgeInsets padding = EdgeInsets.all(size.width * 0.04);
    final bool isLandscape = size.width > size.height;
    final ColorScheme colors = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard Memo'),
        actions: const [
          ThemeModeToggle(),
        ],
      ),
      body: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Barra statistiche.
            buildStatsRow(colors),
            const SizedBox(height: 20),
            // Contenuto principale e pannello laterale.
            Expanded(
              child: _buildContentGrid(context, isLandscape, colors),
            ),
          ],
        ),
      ),
    );
  }

  // Card statistica riutilizzabile.
  Widget statCard(String label, String value, Color bgColor) {
    final Color textColor = _foregroundFor(bgColor);

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
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  // Riga statistiche.
  Widget buildStatsRow(ColorScheme colors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        statCard('Totali', '24', _statColor(colors, _StatType.totali)),
        statCard('Completati', '12', _statColor(colors, _StatType.completati)),
        statCard('Urgenti', '3', _statColor(colors, _StatType.urgenti)),
      ],
    );
  }

  // Grid responsive: stacked in portrait, affiancato in landscape.
  Widget _buildContentGrid(
    BuildContext context,
    bool isLandscape,
    ColorScheme colors,
  ) {
    return GridView.count(
      crossAxisCount: isLandscape ? 2 : 1,
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      childAspectRatio: isLandscape ? 1.6 : 1.25,
      children: [
        _buildTableArea(colors),
        _buildSidePanel(context, colors),
      ],
    );
  }

  // Area tabella con dati principali.
  Widget _buildTableArea(ColorScheme colors) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.outlineVariant),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withOpacity(0.15),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTableHeader(colors),
          const SizedBox(height: 8),
          for (final _MemoRow row in _memoRows) _buildTableRow(row, colors),
        ],
      ),
    );
  }

  Widget _buildTableHeader(ColorScheme colors) {
    return Container(
      decoration: BoxDecoration(
        color: colors.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Row(
        children: [
          _buildTableCell(
            'Titolo',
            flex: 2,
            isHeader: true,
            textColor: colors.onSurfaceVariant,
          ),
          _buildTableCell(
            'Data',
            isHeader: true,
            textColor: colors.onSurfaceVariant,
          ),
          _buildTableCell(
            'Priorita',
            isHeader: true,
            textColor: colors.onSurfaceVariant,
          ),
        ],
      ),
    );
  }

  Widget _buildTableRow(_MemoRow row, ColorScheme colors) {
    final Color rowColor = _rowColor(colors, row.tone);
    final Color textColor = _foregroundFor(rowColor);

    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: rowColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Row(
        children: [
          _buildTableCell(row.title, flex: 2, textColor: textColor),
          _buildTableCell(row.date, textColor: textColor),
          _buildTableCell(row.priority, textColor: textColor),
        ],
      ),
    );
  }

  Widget _buildTableCell(
    String text, {
    int flex = 1,
    bool isHeader = false,
    Color? textColor,
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
            color: textColor,
          ),
        ),
      ),
    );
  }

  // Pannello laterale con note rapide.
  Widget _buildSidePanel(BuildContext context, ColorScheme colors) {
    final Color panelColor = colors.tertiaryContainer;
    final Color panelTextColor = colors.onTertiaryContainer;
    final TextStyle baseStyle = Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(color: panelTextColor) ??
        TextStyle(color: panelTextColor);
    final TextStyle titleStyle = Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(fontWeight: FontWeight.bold, color: panelTextColor) ??
        TextStyle(fontWeight: FontWeight.bold, color: panelTextColor);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: panelColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: DefaultTextStyle(
        style: baseStyle,
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
      ),
    );
  }

  Widget _buildBullet(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('- '),
        Expanded(child: Text(text)),
      ],
    );
  }

  Color _statColor(ColorScheme colors, _StatType type) {
    switch (type) {
      case _StatType.totali:
        return colors.primaryContainer;
      case _StatType.completati:
        return colors.secondaryContainer;
      case _StatType.urgenti:
        return colors.errorContainer;
    }
  }

  Color _rowColor(ColorScheme colors, _RowTone tone) {
    switch (tone) {
      case _RowTone.urgent:
        return colors.errorContainer;
      case _RowTone.neutral:
        return colors.surfaceVariant;
      case _RowTone.success:
        return colors.tertiaryContainer;
    }
  }

  Color _foregroundFor(Color background) {
    return ThemeData.estimateBrightnessForColor(background) == Brightness.dark
        ? Colors.white
        : Colors.black87;
  }
}

class _MemoRow {
  const _MemoRow({
    required this.title,
    required this.date,
    required this.priority,
    required this.tone,
  });

  final String title;
  final String date;
  final String priority;
  final _RowTone tone;
}
