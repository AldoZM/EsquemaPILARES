// lib/widgets/hour_cell.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cell_entry.dart';
import '../models/registro_tipo.dart';
import '../providers/boleta_provider.dart';

class HourCell extends StatelessWidget {
  final int weekIdx;
  final int dayIdx;
  final int hourIdx;
  final CellEntry? entry;
  final String hourLabel;
  final GlobalKey cellKey;

  const HourCell({
    required this.weekIdx,
    required this.dayIdx,
    required this.hourIdx,
    required this.entry,
    required this.hourLabel,
    required this.cellKey,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final bg = entry?.type.cellBackground ?? const Color(0xFFFAFAFA);
    final fg = entry?.type.cellForeground ?? const Color(0xFFCCCCCC);
    final text = entry?.displayValue ?? '—';

    return MouseRegion(
      onEnter: (_) {
        final p = context.read<BoletaProvider>();
        if (p.isPainting) p.paintCell(weekIdx, dayIdx, hourIdx);
      },
      child: Container(
        key: cellKey,
        height: 52,
        decoration: BoxDecoration(
          color: bg,
          border: Border.all(color: const Color(0xFFF0F0F0), width: 0.5),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              hourLabel,
              style: TextStyle(fontSize: 9, color: fg.withValues(alpha: 0.55)),
            ),
            const SizedBox(height: 2),
            Text(
              text,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: fg,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
