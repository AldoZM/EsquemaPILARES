// lib/widgets/week_section.dart
import 'package:flutter/material.dart';
import 'day_column.dart';

class WeekSection extends StatelessWidget {
  final int weekIdx;

  const WeekSection({required this.weekIdx, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          color: const Color(0xFF1B5E35),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          child: Text(
            'SEMANA ${weekIdx + 1}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (int d = 0; d < 7; d++)
                DayColumn(weekIdx: weekIdx, dayIdx: d),
            ],
          ),
        ),
      ],
    );
  }
}
