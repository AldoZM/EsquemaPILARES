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
