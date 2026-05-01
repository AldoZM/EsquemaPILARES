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
