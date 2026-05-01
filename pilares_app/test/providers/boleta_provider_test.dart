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
