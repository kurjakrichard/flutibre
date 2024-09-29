import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/config.dart';
import 'dart:io' show Platform;

import '../providers/providers.dart';

class Flutibre extends ConsumerWidget {
  const Flutibre({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final route = ref.watch(routesProvider);
    final mode = ref.watch(modeProvider);

    if (mode == 'desktop' ||
        mode == '' && Platform.isLinux ||
        Platform.isWindows ||
        Platform.isMacOS) {
      return FluentApp.router(
        debugShowCheckedModeBanner: false,
        theme: FluentThemeData.light(),
        routerConfig: route,
      ); // Desktop-specific code
    } else {
      return MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        routerConfig: route,
      ); //Mobile-specific code
    }
  }
}
