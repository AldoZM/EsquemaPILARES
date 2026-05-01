// lib/widgets/boleta_grid.dart
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/boleta_provider.dart';
import 'week_section.dart';

class BoletaGrid extends StatelessWidget {
  const BoletaGrid({super.key});

  void _paintAtGlobal(Offset globalPos, BoletaProvider provider) {
    for (int w = 0; w < 5; w++) {
      for (int d = 0; d < 7; d++) {
        if (BoletaProvider.weekDates[w][d] == null) continue;
        for (int h = 0; h < 5; h++) {
          final key = provider.getCellKey(w, d, h);
          final box = key.currentContext?.findRenderObject() as RenderBox?;
          if (box == null) continue;
          final cellPos = box.localToGlobal(Offset.zero);
          final cellSize = box.size;
          if (globalPos.dx >= cellPos.dx &&
              globalPos.dx <= cellPos.dx + cellSize.width &&
              globalPos.dy >= cellPos.dy &&
              globalPos.dy <= cellPos.dy + cellSize.height) {
            provider.paintCell(w, d, h);
            return;
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.read<BoletaProvider>();

    return Listener(
      onPointerDown: (e) {
        provider.startPainting();
        _paintAtGlobal(e.position, provider);
      },
      onPointerMove: (e) {
        // Solo para touch — en desktop MouseRegion.onEnter maneja el hover
        if (provider.isPainting && e.kind == PointerDeviceKind.touch) {
          _paintAtGlobal(e.position, provider);
        }
      },
      onPointerUp: (_) => provider.stopPainting(),
      onPointerCancel: (_) => provider.stopPainting(),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFE0E0E0)),
          borderRadius: BorderRadius.circular(10),
        ),
        clipBehavior: Clip.hardEdge,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (int w = 0; w < 5; w++) WeekSection(weekIdx: w),
          ],
        ),
      ),
    );
  }
}
