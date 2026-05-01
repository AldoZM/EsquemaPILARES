// lib/widgets/boleta_header.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/boleta_provider.dart';

class BoletaHeader extends StatelessWidget {
  const BoletaHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final p = context.read<BoletaProvider>();
    return Container(
      color: const Color(0xFF1B5E35),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          const Text(
            'PILARES',
            style: TextStyle(
              color: Colors.white, fontSize: 18,
              fontWeight: FontWeight.w800, letterSpacing: 1,
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'Boleta de Atenciones',
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                p.facilitador,
                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
              ),
              Text(
                '${p.figura} · ${p.periodo}',
                style: const TextStyle(color: Colors.white70, fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
