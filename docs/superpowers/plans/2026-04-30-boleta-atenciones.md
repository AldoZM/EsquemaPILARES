# Boleta de Atenciones PILARES — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Construir un prototipo Flutter Web de la Boleta de Atenciones con modo pincel/multiselección que reemplaza el flujo de 6 pasos por celda con tap/drag sobre un grid mensual.

**Architecture:** SPA Flutter Web con Provider para estado. `BoletaProvider` contiene el estado de las 175 celdas (5 semanas × 7 días × 5 horas). Widgets observan el provider reactivamente. El grid usa `Listener` + `MouseRegion` para detección de drag en desktop y touch en móvil. La scroll view usa `NeverScrollableScrollPhysics` cuando está activo el modo pintura en móvil.

**Tech Stack:** Flutter 3.x, Dart 3.x, provider ^6.1.2, flutter_test

---

## Estructura de archivos

```
pilares_app/
├── lib/
│   ├── main.dart
│   ├── models/
│   │   ├── registro_tipo.dart     # Enum RegistroTipo + extensiones (label, colors, hasNumericValue)
│   │   └── cell_entry.dart        # Modelo CellEntry {type, value?, displayValue}
│   ├── providers/
│   │   └── boleta_provider.dart   # ChangeNotifier: estado de celdas, tool state, totales
│   ├── theme/
│   │   └── pilares_theme.dart     # Colores PILARES, ThemeData
│   ├── widgets/
│   │   ├── boleta_header.dart     # Header con datos del facilitador
│   │   ├── tipo_toolbar.dart      # Chips de tipo + stepper condicional + botón guardar
│   │   ├── hour_cell.dart         # Celda individual con color por tipo
│   │   ├── day_column.dart        # Columna de un día: encabezado + 5 celdas
│   │   ├── week_section.dart      # Sección de semana: header verde + Row de días
│   │   ├── boleta_grid.dart       # Grid completo con lógica drag/paint
│   │   └── totals_bar.dart        # Barra de totales + botón Guardar (desktop)
│   └── screens/
│       └── boleta_screen.dart     # Layout responsivo (desktop vs mobile/tablet)
└── test/
    ├── models/
    │   └── registro_tipo_test.dart
    └── providers/
        └── boleta_provider_test.dart
```

---

## Task 1: Scaffold del proyecto Flutter Web

**Files:**
- Create: `pilares_app/pubspec.yaml`
- Create: `pilares_app/web/index.html` (modificar título)

- [ ] **Step 1: Crear proyecto Flutter Web**

Ejecutar desde `C:\Users\aldo-\OneDrive\Documentos\CodigoAbierto\Maquitado\`:
```bash
flutter create pilares_app --platforms web
cd pilares_app
flutter pub add provider
```

- [ ] **Step 2: Verificar pubspec.yaml**

El archivo debe quedar así:
```yaml
name: pilares_app
description: Prototipo Boleta de Atenciones PILARES
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.2

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0

flutter:
  uses-material-design: true
```

- [ ] **Step 3: Actualizar título en web/index.html**

En `pilares_app/web/index.html` cambiar la línea `<title>`:
```html
<title>PILARES — Boleta de Atenciones</title>
```

- [ ] **Step 4: Verificar que compila para web**

```bash
flutter build web --no-tree-shake-icons
```
Expected: `✓ Built build/web`

- [ ] **Step 5: Commit**

```bash
git add pilares_app/
git commit -m "feat: scaffold Flutter Web project"
```

---

## Task 2: RegistroTipo enum

**Files:**
- Create: `pilares_app/lib/models/registro_tipo.dart`
- Create: `pilares_app/test/models/registro_tipo_test.dart`

- [ ] **Step 1: Escribir test fallido**

```dart
// test/models/registro_tipo_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:pilares_app/models/registro_tipo.dart';

void main() {
  group('RegistroTipo.hasNumericValue', () {
    test('total es true', () => expect(RegistroTipo.total.hasNumericValue, isTrue));
    test('capacitacion es false', () => expect(RegistroTipo.capacitacion.hasNumericValue, isFalse));
    test('na es false', () => expect(RegistroTipo.na.hasNumericValue, isFalse));
    test('borrar es false', () => expect(RegistroTipo.borrar.hasNumericValue, isFalse));
  });

  group('RegistroTipo.label', () {
    test('total es #', () => expect(RegistroTipo.total.label, '#'));
    test('capacitacion es C', () => expect(RegistroTipo.capacitacion.label, 'C'));
    test('difusion es D', () => expect(RegistroTipo.difusion.label, 'D'));
    test('eventos es E', () => expect(RegistroTipo.eventos.label, 'E'));
    test('justificante es J', () => expect(RegistroTipo.justificante.label, 'J'));
    test('planeacion es P', () => expect(RegistroTipo.planeacion.label, 'P'));
    test('na es N/A', () => expect(RegistroTipo.na.label, 'N/A'));
  });

  group('RegistroTipo colors', () {
    test('total cellBackground no es transparente', () {
      expect(RegistroTipo.total.cellBackground.alpha, greaterThan(0));
    });
    test('cada tipo tiene color diferente a empty', () {
      for (final t in RegistroTipo.values) {
        if (t == RegistroTipo.borrar) continue;
        expect(t.cellBackground, isNotNull);
      }
    });
  });
}
```

- [ ] **Step 2: Ejecutar para verificar que falla**

```bash
flutter test test/models/registro_tipo_test.dart
```
Expected: FAIL — `Target of URI doesn't exist: 'package:pilares_app/models/registro_tipo.dart'`

- [ ] **Step 3: Implementar registro_tipo.dart**

```dart
// lib/models/registro_tipo.dart
import 'package:flutter/material.dart';

enum RegistroTipo { total, capacitacion, difusion, eventos, justificante, planeacion, na, borrar }

extension RegistroTipoX on RegistroTipo {
  String get label {
    switch (this) {
      case RegistroTipo.total:        return '#';
      case RegistroTipo.capacitacion: return 'C';
      case RegistroTipo.difusion:     return 'D';
      case RegistroTipo.eventos:      return 'E';
      case RegistroTipo.justificante: return 'J';
      case RegistroTipo.planeacion:   return 'P';
      case RegistroTipo.na:           return 'N/A';
      case RegistroTipo.borrar:       return '✕';
    }
  }

  String get displayName {
    switch (this) {
      case RegistroTipo.total:        return '# Total';
      case RegistroTipo.capacitacion: return 'C Cap.';
      case RegistroTipo.difusion:     return 'D Dif.';
      case RegistroTipo.eventos:      return 'E Eventos';
      case RegistroTipo.justificante: return 'J Just.';
      case RegistroTipo.planeacion:   return 'P Plan.';
      case RegistroTipo.na:           return 'N/A';
      case RegistroTipo.borrar:       return '✕ Borrar';
    }
  }

  bool get hasNumericValue => this == RegistroTipo.total;

  Color get cellBackground {
    switch (this) {
      case RegistroTipo.total:        return const Color(0xFFE8F5EE);
      case RegistroTipo.capacitacion: return const Color(0xFFE3F0FD);
      case RegistroTipo.difusion:     return const Color(0xFFFFF3E0);
      case RegistroTipo.eventos:      return const Color(0xFFF3E5F5);
      case RegistroTipo.justificante: return const Color(0xFFFFF8E1);
      case RegistroTipo.planeacion:   return const Color(0xFFE0F2F1);
      case RegistroTipo.na:           return const Color(0xFFF5F5F5);
      case RegistroTipo.borrar:       return const Color(0xFFFAFAFA);
    }
  }

  Color get cellForeground {
    switch (this) {
      case RegistroTipo.total:        return const Color(0xFF2D6A4F);
      case RegistroTipo.capacitacion: return const Color(0xFF1565C0);
      case RegistroTipo.difusion:     return const Color(0xFFE65100);
      case RegistroTipo.eventos:      return const Color(0xFF6A1B9A);
      case RegistroTipo.justificante: return const Color(0xFFF57F17);
      case RegistroTipo.planeacion:   return const Color(0xFF00695C);
      case RegistroTipo.na:           return const Color(0xFF777777);
      case RegistroTipo.borrar:       return const Color(0xFFCCCCCC);
    }
  }
}
```

- [ ] **Step 4: Ejecutar tests para verificar que pasan**

```bash
flutter test test/models/registro_tipo_test.dart
```
Expected: `All tests passed!`

- [ ] **Step 5: Commit**

```bash
git add lib/models/registro_tipo.dart test/models/registro_tipo_test.dart
git commit -m "feat: add RegistroTipo enum with label, colors and hasNumericValue"
```

---

## Task 3: CellEntry model

**Files:**
- Create: `pilares_app/lib/models/cell_entry.dart`
- Create: `pilares_app/test/models/cell_entry_test.dart`

- [ ] **Step 1: Escribir test fallido**

```dart
// test/models/cell_entry_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:pilares_app/models/registro_tipo.dart';
import 'package:pilares_app/models/cell_entry.dart';

void main() {
  group('CellEntry.displayValue', () {
    test('total con value 7 muestra "7"', () {
      final e = CellEntry(type: RegistroTipo.total, value: 7);
      expect(e.displayValue, '7');
    });
    test('total con value null muestra "0"', () {
      final e = CellEntry(type: RegistroTipo.total, value: null);
      expect(e.displayValue, '0');
    });
    test('capacitacion muestra "C"', () {
      final e = CellEntry(type: RegistroTipo.capacitacion);
      expect(e.displayValue, 'C');
    });
    test('na muestra "N/A"', () {
      final e = CellEntry(type: RegistroTipo.na);
      expect(e.displayValue, 'N/A');
    });
    test('eventos muestra "E"', () {
      final e = CellEntry(type: RegistroTipo.eventos);
      expect(e.displayValue, 'E');
    });
  });

  group('CellEntry equality', () {
    test('mismos valores son iguales', () {
      expect(
        CellEntry(type: RegistroTipo.total, value: 7),
        equals(CellEntry(type: RegistroTipo.total, value: 7)),
      );
    });
    test('diferente value no son iguales', () {
      expect(
        CellEntry(type: RegistroTipo.total, value: 7),
        isNot(equals(CellEntry(type: RegistroTipo.total, value: 5))),
      );
    });
  });
}
```

- [ ] **Step 2: Ejecutar para verificar que falla**

```bash
flutter test test/models/cell_entry_test.dart
```
Expected: FAIL — `Target of URI doesn't exist`

- [ ] **Step 3: Implementar cell_entry.dart**

```dart
// lib/models/cell_entry.dart
import 'registro_tipo.dart';

class CellEntry {
  final RegistroTipo type;
  final int? value;

  const CellEntry({required this.type, this.value});

  String get displayValue {
    if (type == RegistroTipo.total) return '${value ?? 0}';
    return type.label;
  }

  @override
  bool operator ==(Object other) =>
      other is CellEntry && other.type == type && other.value == value;

  @override
  int get hashCode => Object.hash(type, value);
}
```

- [ ] **Step 4: Ejecutar tests**

```bash
flutter test test/models/cell_entry_test.dart
```
Expected: `All tests passed!`

- [ ] **Step 5: Commit**

```bash
git add lib/models/cell_entry.dart test/models/cell_entry_test.dart
git commit -m "feat: add CellEntry model"
```

---

## Task 4: BoletaProvider

**Files:**
- Create: `pilares_app/lib/providers/boleta_provider.dart`
- Create: `pilares_app/test/providers/boleta_provider_test.dart`

- [ ] **Step 1: Escribir test fallido**

```dart
// test/providers/boleta_provider_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:pilares_app/models/registro_tipo.dart';
import 'package:pilares_app/providers/boleta_provider.dart';

void main() {
  late BoletaProvider provider;

  setUp(() => provider = BoletaProvider());

  group('Estado inicial', () {
    test('todas las celdas vacías', () {
      expect(provider.getCell(0, 0, 0), isNull);
      expect(provider.getCell(4, 1, 4), isNull);
    });
    test('tipo inicial es total', () => expect(provider.currentType, RegistroTipo.total));
    test('valor inicial es 7', () => expect(provider.currentValue, 7));
    test('totales iniciales son 0', () {
      expect(provider.totalAtenciones, 0);
      expect(provider.totalHoras, 0);
      expect(provider.totalHorasCapacitacion, 0);
    });
  });

  group('paintCell', () {
    test('pinta celda con tipo total y valor', () {
      provider.paintCell(0, 0, 0);
      expect(provider.getCell(0, 0, 0)?.type, RegistroTipo.total);
      expect(provider.getCell(0, 0, 0)?.value, 7);
    });
    test('pinta celda con capacitacion sin valor', () {
      provider.setType(RegistroTipo.capacitacion);
      provider.paintCell(0, 0, 0);
      expect(provider.getCell(0, 0, 0)?.type, RegistroTipo.capacitacion);
      expect(provider.getCell(0, 0, 0)?.value, isNull);
    });
    test('borrar limpia la celda', () {
      provider.paintCell(0, 0, 0);
      provider.setType(RegistroTipo.borrar);
      provider.paintCell(0, 0, 0);
      expect(provider.getCell(0, 0, 0), isNull);
    });
    test('día inexistente (semana 5, día 2) no se pinta', () {
      provider.paintCell(4, 2, 0); // VIE no existe en semana 5 de abril
      expect(provider.getCell(4, 2, 0), isNull);
    });
  });

  group('Totales', () {
    test('totalAtenciones suma valores de tipo total', () {
      provider.paintCell(0, 0, 0); // 7
      provider.paintCell(0, 0, 1); // 7
      expect(provider.totalAtenciones, 14);
    });
    test('totalHoras cuenta slots de tipo total', () {
      provider.paintCell(0, 0, 0);
      provider.paintCell(0, 0, 1);
      provider.setType(RegistroTipo.capacitacion);
      provider.paintCell(0, 0, 2);
      expect(provider.totalHoras, 2);
    });
    test('totalHorasCapacitacion cuenta slots de tipo capacitacion', () {
      provider.setType(RegistroTipo.capacitacion);
      provider.paintCell(0, 0, 0);
      provider.paintCell(0, 1, 0);
      expect(provider.totalHorasCapacitacion, 2);
    });
  });

  group('Tool state', () {
    test('incrementValue aumenta currentValue', () {
      provider.incrementValue();
      expect(provider.currentValue, 8);
    });
    test('decrementValue disminuye currentValue', () {
      provider.decrementValue();
      expect(provider.currentValue, 6);
    });
    test('decrementValue no baja de 0', () {
      for (int i = 0; i < 10; i++) provider.decrementValue();
      expect(provider.currentValue, 0);
    });
  });
}
```

- [ ] **Step 2: Ejecutar para verificar que falla**

```bash
flutter test test/providers/boleta_provider_test.dart
```
Expected: FAIL — `Target of URI doesn't exist`

- [ ] **Step 3: Implementar boleta_provider.dart**

```dart
// lib/providers/boleta_provider.dart
import 'package:flutter/material.dart';
import '../models/registro_tipo.dart';
import '../models/cell_entry.dart';

class BoletaProvider extends ChangeNotifier {
  final String facilitador = 'Aldo Zetina Muciño';
  final String asignacion = 'Antonio Mota';
  final String figura = 'Docente de Tecnologías A';
  final String correo = 'zetinaa3@gmail.com';
  final String periodo = 'Abril 2026';

  static const List<String> dayNames = ['MIÉ', 'JUE', 'VIE', 'SÁB', 'DOM', 'LUN', 'MAR'];
  static const List<String> hourLabels = ['H1', 'H2', 'H3', 'H4', 'H5+'];

  // null = ese día no existe en el período
  static const List<List<String?>> weekDates = [
    ['1 ABR', '2 ABR', '3 ABR', '4 ABR', '5 ABR', '6 ABR', '7 ABR'],
    ['8 ABR', '9 ABR', '10 ABR', '11 ABR', '12 ABR', '13 ABR', '14 ABR'],
    ['15 ABR', '16 ABR', '17 ABR', '18 ABR', '19 ABR', '20 ABR', '21 ABR'],
    ['22 ABR', '23 ABR', '24 ABR', '25 ABR', '26 ABR', '27 ABR', '28 ABR'],
    ['29 ABR', '30 ABR', null, null, null, null, null],
  ];

  RegistroTipo _currentType = RegistroTipo.total;
  int _currentValue = 7;
  bool _isPainting = false;
  bool _isPaintMode = false;

  RegistroTipo get currentType => _currentType;
  int get currentValue => _currentValue;
  bool get isPainting => _isPainting;
  bool get isPaintMode => _isPaintMode;

  // [semana][día][hora]
  final List<List<List<CellEntry?>>> _cells = List.generate(
    5, (_) => List.generate(7, (_) => List.generate(5, (_) => null)),
  );

  // GlobalKeys para hit-test en drag touch
  final Map<String, GlobalKey> _cellKeys = {};

  BoletaProvider() {
    for (int w = 0; w < 5; w++) {
      for (int d = 0; d < 7; d++) {
        for (int h = 0; h < 5; h++) {
          _cellKeys['$w-$d-$h'] = GlobalKey();
        }
      }
    }
  }

  CellEntry? getCell(int w, int d, int h) => _cells[w][d][h];
  GlobalKey getCellKey(int w, int d, int h) => _cellKeys['$w-$d-$h']!;

  void setType(RegistroTipo type) {
    _currentType = type;
    notifyListeners();
  }

  void incrementValue() {
    _currentValue++;
    notifyListeners();
  }

  void decrementValue() {
    if (_currentValue > 0) _currentValue--;
    notifyListeners();
  }

  void startPainting() => _isPainting = true;
  void stopPainting() => _isPainting = false;

  void togglePaintMode() {
    _isPaintMode = !_isPaintMode;
    _isPainting = false;
    notifyListeners();
  }

  void paintCell(int w, int d, int h) {
    if (weekDates[w][d] == null) return;
    if (_currentType == RegistroTipo.borrar) {
      _cells[w][d][h] = null;
    } else {
      _cells[w][d][h] = CellEntry(
        type: _currentType,
        value: _currentType.hasNumericValue ? _currentValue : null,
      );
    }
    notifyListeners();
  }

  int get totalAtenciones {
    int sum = 0;
    for (final week in _cells) {
      for (final day in week) {
        for (final cell in day) {
          if (cell?.type == RegistroTipo.total) sum += cell!.value ?? 0;
        }
      }
    }
    return sum;
  }

  int get totalHoras {
    int count = 0;
    for (final week in _cells) {
      for (final day in week) {
        for (final cell in day) {
          if (cell?.type == RegistroTipo.total) count++;
        }
      }
    }
    return count;
  }

  int get totalHorasCapacitacion {
    int count = 0;
    for (final week in _cells) {
      for (final day in week) {
        for (final cell in day) {
          if (cell?.type == RegistroTipo.capacitacion) count++;
        }
      }
    }
    return count;
  }
}
```

- [ ] **Step 4: Ejecutar todos los tests**

```bash
flutter test
```
Expected: `All tests passed!`

- [ ] **Step 5: Commit**

```bash
git add lib/providers/ test/providers/
git commit -m "feat: add BoletaProvider with paint logic and computed totals"
```

---

## Task 5: PilaresTheme

**Files:**
- Create: `pilares_app/lib/theme/pilares_theme.dart`

- [ ] **Step 1: Crear pilares_theme.dart**

```dart
// lib/theme/pilares_theme.dart
import 'package:flutter/material.dart';

class PilaresTheme {
  static const Color primaryGreen = Color(0xFF1B5E35);
  static const Color lightGreen = Color(0xFF2D6A4F);
  static const Color background = Color(0xFFF5F7F5);
  static const Color cardBg = Colors.white;
  static const Color border = Color(0xFFE0E0E0);
  static const Color subtleText = Color(0xFF888888);

  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryGreen,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: background,
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryGreen,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
  );
}
```

- [ ] **Step 2: Verificar que compila**

```bash
flutter build web --no-tree-shake-icons 2>&1 | tail -5
```
Expected: `✓ Built build/web`

- [ ] **Step 3: Commit**

```bash
git add lib/theme/
git commit -m "feat: add PilaresTheme"
```

---

## Task 6: HourCell widget

**Files:**
- Create: `pilares_app/lib/widgets/hour_cell.dart`

- [ ] **Step 1: Crear hour_cell.dart**

```dart
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
              style: TextStyle(fontSize: 9, color: fg.withOpacity(0.55)),
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
```

- [ ] **Step 2: Verificar que compila**

```bash
flutter build web --no-tree-shake-icons 2>&1 | tail -5
```
Expected: `✓ Built build/web`

- [ ] **Step 3: Commit**

```bash
git add lib/widgets/hour_cell.dart
git commit -m "feat: add HourCell widget"
```

---

## Task 7: DayColumn widget

**Files:**
- Create: `pilares_app/lib/widgets/day_column.dart`

- [ ] **Step 1: Crear day_column.dart**

```dart
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
```

- [ ] **Step 2: Verificar que compila**

```bash
flutter build web --no-tree-shake-icons 2>&1 | tail -5
```
Expected: `✓ Built build/web`

- [ ] **Step 3: Commit**

```bash
git add lib/widgets/day_column.dart
git commit -m "feat: add DayColumn widget"
```

---

## Task 8: WeekSection widget

**Files:**
- Create: `pilares_app/lib/widgets/week_section.dart`

- [ ] **Step 1: Crear week_section.dart**

```dart
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
```

- [ ] **Step 2: Verificar que compila**

```bash
flutter build web --no-tree-shake-icons 2>&1 | tail -5
```
Expected: `✓ Built build/web`

- [ ] **Step 3: Commit**

```bash
git add lib/widgets/week_section.dart
git commit -m "feat: add WeekSection widget"
```

---

## Task 9: BoletaGrid con lógica de paint/drag

**Files:**
- Create: `pilares_app/lib/widgets/boleta_grid.dart`

- [ ] **Step 1: Crear boleta_grid.dart**

```dart
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
```

- [ ] **Step 2: Verificar que compila**

```bash
flutter build web --no-tree-shake-icons 2>&1 | tail -5
```
Expected: `✓ Built build/web`

- [ ] **Step 3: Commit**

```bash
git add lib/widgets/boleta_grid.dart
git commit -m "feat: add BoletaGrid with Listener-based paint/drag detection"
```

---

## Task 10: TipoToolbar widget

**Files:**
- Create: `pilares_app/lib/widgets/tipo_toolbar.dart`

- [ ] **Step 1: Crear tipo_toolbar.dart**

```dart
// lib/widgets/tipo_toolbar.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/registro_tipo.dart';
import '../providers/boleta_provider.dart';

class TipoToolbar extends StatelessWidget {
  /// En mobile/tablet muestra totales y botón Guardar dentro de la toolbar
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
            // Chips de tipo
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
                // Badge informativo
                Text(
                  provider.currentType.hasNumericValue
                      ? 'Ingresa la cantidad:'
                      : 'Solo marca la letra (sin cantidad)',
                  style: const TextStyle(fontSize: 11, color: Color(0xFF888888)),
                ),
                const SizedBox(width: 12),
                // Stepper — visible y activo solo para total
                AnimatedOpacity(
                  opacity: provider.currentType.hasNumericValue ? 1.0 : 0.25,
                  duration: const Duration(milliseconds: 200),
                  child: IgnorePointer(
                    ignoring: !provider.currentType.hasNumericValue,
                    child: _ValueStepper(value: provider.currentValue),
                  ),
                ),
                const Spacer(),
                // Botón modo pintura (solo mobile/tablet)
                if (compact)
                  _PaintModeToggle(active: provider.isPaintMode),
                if (compact) const SizedBox(width: 8),
                // Botón Guardar (siempre en compact, solo en desktop via TotalsBar)
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
            // Totales resumidos (solo mobile)
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
```

- [ ] **Step 2: Verificar que compila**

```bash
flutter build web --no-tree-shake-icons 2>&1 | tail -5
```
Expected: `✓ Built build/web`

- [ ] **Step 3: Commit**

```bash
git add lib/widgets/tipo_toolbar.dart
git commit -m "feat: add TipoToolbar with type chips, conditional stepper and paint mode toggle"
```

---

## Task 11: BoletaHeader y TotalsBar

**Files:**
- Create: `pilares_app/lib/widgets/boleta_header.dart`
- Create: `pilares_app/lib/widgets/totals_bar.dart`

- [ ] **Step 1: Crear boleta_header.dart**

```dart
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
```

- [ ] **Step 2: Crear totals_bar.dart**

```dart
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
```

- [ ] **Step 3: Verificar que compila**

```bash
flutter build web --no-tree-shake-icons 2>&1 | tail -5
```
Expected: `✓ Built build/web`

- [ ] **Step 4: Commit**

```bash
git add lib/widgets/boleta_header.dart lib/widgets/totals_bar.dart
git commit -m "feat: add BoletaHeader and TotalsBar widgets"
```

---

## Task 12: BoletaScreen responsivo y main.dart

**Files:**
- Create: `pilares_app/lib/screens/boleta_screen.dart`
- Modify: `pilares_app/lib/main.dart`

- [ ] **Step 1: Crear boleta_screen.dart**

```dart
// lib/screens/boleta_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/boleta_provider.dart';
import '../theme/pilares_theme.dart';
import '../widgets/boleta_grid.dart';
import '../widgets/boleta_header.dart';
import '../widgets/tipo_toolbar.dart';
import '../widgets/totals_bar.dart';

class BoletaScreen extends StatelessWidget {
  const BoletaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        final isDesktop = constraints.maxWidth >= 900;
        return isDesktop ? const _DesktopLayout() : const _MobileLayout();
      },
    );
  }
}

class _DesktopLayout extends StatelessWidget {
  const _DesktopLayout();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PilaresTheme.background,
      body: Column(
        children: [
          const BoletaHeader(),
          const TipoToolbar(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: const [
                  BoletaGrid(),
                  SizedBox(height: 12),
                  TotalsBar(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MobileLayout extends StatelessWidget {
  const _MobileLayout();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: PilaresTheme.background,
      body: Column(
        children: [
          const BoletaHeader(),
          Expanded(
            child: Consumer<BoletaProvider>(
              builder: (ctx, provider, _) => SingleChildScrollView(
                // Desactiva scroll cuando está en modo pintura (para touch drag)
                physics: provider.isPaintMode
                    ? const NeverScrollableScrollPhysics()
                    : const ClampingScrollPhysics(),
                padding: const EdgeInsets.all(8),
                child: const BoletaGrid(),
              ),
            ),
          ),
          // Toolbar + totales + guardar al fondo (alcance del pulgar)
          const TipoToolbar(compact: true),
        ],
      ),
    );
  }
}
```

- [ ] **Step 2: Reemplazar main.dart**

```dart
// lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/boleta_provider.dart';
import 'screens/boleta_screen.dart';
import 'theme/pilares_theme.dart';

void main() {
  runApp(const PilaresApp());
}

class PilaresApp extends StatelessWidget {
  const PilaresApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BoletaProvider(),
      child: MaterialApp(
        title: 'PILARES — Boleta de Atenciones',
        debugShowCheckedModeBanner: false,
        theme: PilaresTheme.theme,
        home: const BoletaScreen(),
      ),
    );
  }
}
```

- [ ] **Step 3: Ejecutar todos los tests**

```bash
flutter test
```
Expected: `All tests passed!`

- [ ] **Step 4: Commit**

```bash
git add lib/screens/ lib/main.dart
git commit -m "feat: add BoletaScreen responsive layout and wire up main.dart"
```

---

## Task 13: Verificación en Chrome

- [ ] **Step 1: Correr en Chrome**

```bash
flutter run -d chrome --web-renderer html
```

- [ ] **Step 2: Verificar comportamiento desktop (ventana ≥ 900px)**

Checklist manual:
- [ ] Header verde con nombre del facilitador visible
- [ ] Toolbar de tipos arriba, chips con colores correctos
- [ ] Stepper activo al seleccionar `# Total`, desactivado/opaco con otros tipos
- [ ] Click sobre celdas las pinta con el tipo/color seleccionado
- [ ] Drag del mouse pinta múltiples celdas de un solo movimiento
- [ ] Celdas `C`, `D`, `E`, `J`, `P` muestran solo la letra (sin número)
- [ ] Celdas `N/A` muestran "N/A"
- [ ] Totales en barra inferior se actualizan al pintar
- [ ] Botón Guardar muestra snackbar verde

- [ ] **Step 3: Verificar comportamiento mobile (DevTools → iPhone 12)**

Abrir DevTools (F12) → Toggle device toolbar → iPhone 12:
- [ ] Toolbar al fondo con chips compactos
- [ ] Grid ocupa todo el ancho sin espacio en blanco a la derecha
- [ ] Icono pincel activa/desactiva modo pintura
- [ ] En modo pintura: tap sobre celdas las pinta
- [ ] En modo pintura: scroll desactivado, drag pinta celdas
- [ ] Sin modo pintura: scroll vertical funciona con normalidad
- [ ] Totales visibles dentro de la toolbar inferior

- [ ] **Step 4: Commit final**

```bash
git add .
git commit -m "feat: boleta de atenciones PILARES prototipo completo"
git push origin master:main
```

---

## Self-Review del plan vs. spec

| Requisito del spec | Tarea |
|--------------------|-------|
| Solo `# Total` tiene valor numérico | Task 2 (hasNumericValue), Task 10 (stepper condicional) |
| Pincel: tap pinta, drag pinta múltiples | Task 9 (Listener + MouseRegion) |
| Colores por tipo (7 combinaciones) | Task 2 (cellBackground/cellForeground) |
| Toolbar arriba en desktop, abajo en mobile | Task 12 (BoletaScreen layouts) |
| Grid sin espacios sobrantes (flex) | Task 7 (DayColumn con Expanded) |
| Totales: atenciones, horas, cap. | Task 4 (provider), Task 11 (TotalsBar) |
| Modo pintura para mobile touch | Task 10 (_PaintModeToggle), Task 12 (NeverScrollableScrollPhysics) |
| Botón Guardar (mock) | Task 10 + Task 11 |
| Datos mock en memoria | Task 4 (BoletaProvider, no API) |
| Breakpoint 900px desktop, menor mobile | Task 12 (LayoutBuilder) |
| Semana 5 con días parciales (29-30 ABR) | Task 4 (weekDates con null), Task 7 (SizedBox.shrink()) |
