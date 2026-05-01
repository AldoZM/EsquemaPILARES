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
      case RegistroTipo.total:        return '# Total de Atenciones';
      case RegistroTipo.capacitacion: return 'C — Capacitación';
      case RegistroTipo.difusion:     return 'D — Difusión';
      case RegistroTipo.eventos:      return 'E — Apoyo en Eventos';
      case RegistroTipo.justificante: return 'J — Justificante';
      case RegistroTipo.planeacion:   return 'P — Planeación';
      case RegistroTipo.na:           return 'N/A — No Aplica';
      case RegistroTipo.borrar:       return '✕ Borrar celda';
    }
  }

  String get description {
    switch (this) {
      case RegistroTipo.total:        return 'Ingresa cuántas personas atendiste en esa hora';
      case RegistroTipo.capacitacion: return 'Hora dedicada a tu propia capacitación como facilitador';
      case RegistroTipo.difusion:     return 'Hora dedicada a difundir el programa PILARES';
      case RegistroTipo.eventos:      return 'Apoyo o participación en un evento especial';
      case RegistroTipo.justificante: return 'Hora justificada mediante comprobante oficial';
      case RegistroTipo.planeacion:   return 'Hora dedicada a planear tus actividades del mes';
      case RegistroTipo.na:           return 'Esta hora no corresponde a ningún registro';
      case RegistroTipo.borrar:       return 'Toca una celda para eliminar su contenido';
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
