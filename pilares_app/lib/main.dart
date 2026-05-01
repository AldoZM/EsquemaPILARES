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
