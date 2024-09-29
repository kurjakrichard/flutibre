import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers.dart';

final modeProvider = StateNotifierProvider<ModeProvider, String>((ref) {
  return ModeProvider(ref: ref);
});

class ModeProvider extends StateNotifier<String> {
  ModeProvider({required this.ref}) : super('') {
    state = ref.watch(sharedUtilityProvider).getMode();
  }
  Ref ref;

  void setMode(String newValue) {
    ref.watch(sharedUtilityProvider).setMode(
          mode: newValue,
        );
    state = ref.watch(sharedUtilityProvider).getMode();
  }
}
