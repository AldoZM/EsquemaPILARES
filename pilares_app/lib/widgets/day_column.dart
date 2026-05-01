// lib/widgets/day_column.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/boleta_provider.dart';
import 'hour_cell.dart';

class DayColumn extends StatelessWidget {
  final int weekIdx;
  final int dayIdx;

  const DayColumn({required this.weekIdx, required this.dayIdx, super.key});

  @override
  Widget build(BuildContext context) {
    final date = BoletaProvider.weekDates[weekIdx][dayIdx];
    if (date == null) return const SizedBox.shrink();

    final dayName = BoletaProvider.dayNames[dayIdx];

    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            color: const Color(0xFFF0F4F1),
            padding: const EdgeInsets.symmetric(vertical: 5),
            alignment: Alignment.center,
            child: Text(
              dayName,
              style: const TextStyle(
                fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF2D6A4F),
              ),
            ),
          ),
          Container(
            color: const Color(0xFFF8FAF8),
            padding: const EdgeInsets.symmetric(vertical: 3),
            alignment: Alignment.center,
            child: Text(
              date,
              style: const TextStyle(fontSize: 9, color: Color(0xFF888888)),
            ),
          ),
          Consumer<BoletaProvider>(
            builder: (ctx, provider, _) => Row(
              children: [
                for (int h = 0; h < BoletaProvider.hourLabels.length; h++)
                  Expanded(
                    child: HourCell(
                      weekIdx: weekIdx,
                      dayIdx: dayIdx,
                      hourIdx: h,
                      entry: provider.getCell(weekIdx, dayIdx, h),
                      hourLabel: BoletaProvider.hourLabels[h],
                      cellKey: provider.getCellKey(weekIdx, dayIdx, h),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
