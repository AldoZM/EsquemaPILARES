// lib/widgets/totals_bar.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/boleta_provider.dart';

class TotalsBar extends StatelessWidget {
  const TotalsBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BoletaProvider>(
      builder: (ctx, provider, _) => Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Color(0xFFE0E0E0))),
        ),
        child: Row(
          children: [
            _TotalItem(label: 'Total de horas mensual', value: provider.totalHoras),
            const SizedBox(width: 28),
            _TotalItem(label: 'Total de atenciones mensual', value: provider.totalAtenciones),
            const SizedBox(width: 28),
            _TotalItem(label: 'Horas de capacitación', value: provider.totalHorasCapacitacion),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: () => ScaffoldMessenger.of(ctx).showSnackBar(
                const SnackBar(
                  content: Text('Boleta guardada correctamente (mock)'),
                  backgroundColor: Color(0xFF1B5E35),
                ),
              ),
              icon: const Icon(Icons.save_alt, size: 18),
              label: const Text('Guardar Boleta', style: TextStyle(fontWeight: FontWeight.w700)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1B5E35),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TotalItem extends StatelessWidget {
  final String label;
  final int value;

  const _TotalItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Color(0xFF888888))),
        Text(
          '$value',
          style: const TextStyle(
            fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF1B5E35),
          ),
        ),
      ],
    );
  }
}
