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
                physics: provider.isPaintMode
                    ? const NeverScrollableScrollPhysics()
                    : const ClampingScrollPhysics(),
                padding: const EdgeInsets.all(8),
                child: const BoletaGrid(),
              ),
            ),
          ),
          const TipoToolbar(compact: true),
        ],
      ),
    );
  }
}
