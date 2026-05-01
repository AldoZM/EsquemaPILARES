// lib/widgets/tipo_toolbar.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/registro_tipo.dart';
import '../providers/boleta_provider.dart';

class TipoToolbar extends StatelessWidget {
  final bool compact;

  const TipoToolbar({this.compact = false, super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BoletaProvider>(
      builder: (ctx, provider, _) => Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xFFE0E0E0))),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final tipo in RegistroTipo.values)
                  _TipoChip(tipo: tipo, selected: provider.currentType == tipo),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  provider.currentType.hasNumericValue
                      ? 'Ingresa la cantidad:'
                      : 'Solo marca la letra (sin cantidad)',
                  style: const TextStyle(fontSize: 11, color: Color(0xFF888888)),
                ),
                const SizedBox(width: 12),
                AnimatedOpacity(
                  opacity: provider.currentType.hasNumericValue ? 1.0 : 0.25,
                  duration: const Duration(milliseconds: 200),
                  child: IgnorePointer(
                    ignoring: !provider.currentType.hasNumericValue,
                    child: _ValueStepper(value: provider.currentValue),
                  ),
                ),
                const Spacer(),
                if (compact)
                  _PaintModeToggle(active: provider.isPaintMode),
                if (compact) const SizedBox(width: 8),
                if (compact)
                  ElevatedButton(
                    onPressed: () => _onGuardar(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1B5E35),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Guardar', style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
              ],
            ),
            if (compact)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Row(
                  children: [
                    _TotalChip(label: 'Atenciones', value: provider.totalAtenciones),
                    const SizedBox(width: 12),
                    _TotalChip(label: 'Horas', value: provider.totalHoras),
                    const SizedBox(width: 12),
                    _TotalChip(label: 'Capacitación', value: provider.totalHorasCapacitacion),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _onGuardar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Boleta guardada correctamente (mock)'),
        backgroundColor: Color(0xFF1B5E35),
      ),
    );
  }
}

class _TipoChip extends StatelessWidget {
  final RegistroTipo tipo;
  final bool selected;

  const _TipoChip({required this.tipo, required this.selected});

  @override
  Widget build(BuildContext context) {
    final fg = tipo.cellForeground;
    final bg = selected ? Colors.white : tipo.cellBackground;

    return GestureDetector(
      onTap: () => context.read<BoletaProvider>().setType(tipo),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? fg : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8, height: 8,
              decoration: BoxDecoration(color: fg, shape: BoxShape.circle),
            ),
            const SizedBox(width: 5),
            Text(
              tipo.displayName,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: fg),
            ),
          ],
        ),
      ),
    );
  }
}

class _ValueStepper extends StatelessWidget {
  final int value;

  const _ValueStepper({required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFDDDDDD), width: 1.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepButton(
            icon: Icons.remove,
            onTap: () => context.read<BoletaProvider>().decrementValue(),
          ),
          SizedBox(
            width: 36,
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
          ),
          _StepButton(
            icon: Icons.add,
            onTap: () => context.read<BoletaProvider>().incrementValue(),
          ),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _StepButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 32, height: 32,
        color: const Color(0xFFF5F5F5),
        child: Icon(icon, size: 18, color: const Color(0xFF333333)),
      ),
    );
  }
}

class _PaintModeToggle extends StatelessWidget {
  final bool active;

  const _PaintModeToggle({required this.active});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: active ? 'Modo pintura activo (scroll desactivado)' : 'Activar modo pintura',
      child: GestureDetector(
        onTap: () => context.read<BoletaProvider>().togglePaintMode(),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: active ? const Color(0xFF1B5E35) : const Color(0xFFF0F0F0),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.brush,
            size: 20,
            color: active ? Colors.white : const Color(0xFF555555),
          ),
        ),
      ),
    );
  }
}

class _TotalChip extends StatelessWidget {
  final String label;
  final int value;

  const _TotalChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 9, color: Color(0xFF888888))),
        Text('$value', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF1B5E35))),
      ],
    );
  }
}
