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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: Color(0xFFE0E0E0))),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Instrucciones de uso
            if (!compact)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5EE),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFB2DFCC)),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.info_outline, color: Color(0xFF2D6A4F), size: 20),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        '¿Cómo registrar? — Paso 1: Selecciona el tipo de registro. '
                        'Paso 2: Si elegiste "Total de Atenciones", ajusta la cantidad. '
                        'Paso 3: Haz clic o arrastra sobre las celdas del calendario.',
                        style: TextStyle(fontSize: 13, color: Color(0xFF1B5E35)),
                      ),
                    ),
                  ],
                ),
              ),

            // Etiqueta de sección
            const Text(
              'TIPO DE REGISTRO',
              style: TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.w800,
                color: Color(0xFF888888),
                letterSpacing: 0.8,
              ),
            ),
            const SizedBox(height: 8),

            // Chips de tipo
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final tipo in RegistroTipo.values)
                  _TipoChip(tipo: tipo, selected: provider.currentType == tipo),
              ],
            ),
            const SizedBox(height: 12),

            // Descripción del tipo seleccionado
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Container(
                key: ValueKey(provider.currentType),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: provider.currentType.cellBackground,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.lightbulb_outline,
                        color: provider.currentType.cellForeground, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        provider.currentType.description,
                        style: TextStyle(
                          fontSize: 9,
                          color: provider.currentType.cellForeground,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Cantidad (solo para Total de Atenciones)
            if (provider.currentType.hasNumericValue) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text(
                    'Cantidad de atenciones por celda:',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF333333),
                    ),
                  ),
                  const SizedBox(width: 16),
                  _ValueStepper(value: provider.currentValue),
                ],
              ),
            ],

            // Fila inferior (modo pintura + guardar en compact, totales en compact)
            if (compact) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  _PaintModeToggle(active: provider.isPaintMode),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Row(
                      children: [
                        _TotalChip(label: 'Atenciones', value: provider.totalAtenciones),
                        const SizedBox(width: 16),
                        _TotalChip(label: 'Horas', value: provider.totalHoras),
                        const SizedBox(width: 16),
                        _TotalChip(label: 'Capacitación', value: provider.totalHorasCapacitacion),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: () => _onGuardar(context),
                    icon: const Icon(Icons.save_alt, size: 18),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1B5E35),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    label: const Text('Guardar',
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _onGuardar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✓ Boleta guardada correctamente'),
        backgroundColor: Color(0xFF1B5E35),
        duration: Duration(seconds: 3),
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

    return Tooltip(
      message: tipo.description,
      preferBelow: true,
      child: GestureDetector(
        onTap: () => context.read<BoletaProvider>().setType(tipo),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: selected ? fg : Colors.transparent,
              width: 2.5,
            ),
            boxShadow: selected
                ? [BoxShadow(color: fg.withValues(alpha: 0.25), blurRadius: 6, offset: const Offset(0, 2))]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 10, height: 10,
                decoration: BoxDecoration(color: fg, shape: BoxShape.circle),
              ),
              const SizedBox(width: 7),
              Text(
                tipo.displayName,
                style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: fg),
              ),
              if (selected) ...[
                const SizedBox(width: 6),
                Icon(Icons.check_circle, size: 15, color: fg),
              ],
            ],
          ),
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
        border: Border.all(color: const Color(0xFF2D6A4F), width: 1.5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepButton(
            icon: Icons.remove,
            onTap: () => context.read<BoletaProvider>().decrementValue(),
          ),
          Container(
            width: 35,
            padding: const EdgeInsets.symmetric(vertical: 4),
            alignment: Alignment.center,
            child: Text(
              '$value',
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 14,
                color: Color(0xFF1B5E35),
              ),
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
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 30,
        height: 30,
        decoration: const BoxDecoration(color: Color(0xFFE8F5EE)),
        child: Icon(icon, size: 15, color: Color(0xFF1B5E35)),
      ),
    );
  }
}

class _PaintModeToggle extends StatelessWidget {
  final bool active;

  const _PaintModeToggle({required this.active});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.read<BoletaProvider>().togglePaintMode(),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: active ? const Color(0xFF1B5E35) : const Color(0xFFF0F0F0),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: active ? const Color(0xFF1B5E35) : const Color(0xFFCCCCCC),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.brush, size: 20,
                color: active ? Colors.white : const Color(0xFF555555)),
            const SizedBox(width: 6),
            Text(
              active ? 'Pincel ON' : 'Pincel',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: active ? Colors.white : const Color(0xFF555555),
              ),
            ),
          ],
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
        Text(label,
            style: const TextStyle(fontSize: 11, color: Color(0xFF888888),
                fontWeight: FontWeight.w600)),
        Text('$value',
            style: const TextStyle(
                fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF1B5E35))),
      ],
    );
  }
}
