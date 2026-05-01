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
