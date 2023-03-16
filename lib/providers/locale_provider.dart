import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../l10n/l10n.dart';
import 'shared_utility_provider.dart';

class LocaleProvider extends StateNotifier<String> {
  LocaleProvider({required this.ref}) : super('en') {
    state = ref.watch(sharedUtilityProvider).getLocaleKey();
  }
  Ref ref;

  void setLocale(String newValue) {
    if (!L10n.locales.contains(Locale(newValue))) return;
    ref.watch(sharedUtilityProvider).setLocale(
          locale: newValue,
        );
    state = ref.watch(sharedUtilityProvider).getLocaleKey();
  }
}
