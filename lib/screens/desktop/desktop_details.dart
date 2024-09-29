import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DesktopDetails extends StatelessWidget {
  static DesktopDetails builder(
    BuildContext context,
    GoRouterState state,
  ) =>
      const DesktopDetails();
  const DesktopDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Center(
        child: Text(''),
      ),
    );
  }
}
