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
