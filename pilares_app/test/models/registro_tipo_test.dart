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
