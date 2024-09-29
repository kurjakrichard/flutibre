import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DesktopHome extends StatelessWidget {
  static DesktopHome builder(
    BuildContext context,
    GoRouterState state,
  ) =>
      const DesktopHome();
  const DesktopHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutibre'),
      ),
      body: const Center(
        child: Text('Desktop'),
      ),
    );
  }
}
