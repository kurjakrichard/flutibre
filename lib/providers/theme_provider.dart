import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'shared_preferences_provider.dart';

class ThemeProvider extends StateNotifier<bool> {
  ThemeProvider({required this.ref}) : super(false) {
    state = ref.watch(sharedUtilityProvider).isDarkTheme();
  }
  Ref ref;

  void toggleTheme() {
    ref.watch(sharedUtilityProvider).setDarkMode(
          isdark: !ref.watch(sharedUtilityProvider).isDarkTheme(),
        );
    state = ref.watch(sharedUtilityProvider).isDarkTheme();
  }
}
