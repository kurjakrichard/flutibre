import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'shared_preferences_provider.dart';

class PathProvider extends StateNotifier<String> {
  PathProvider({required this.ref}) : super('') {
    state = ref.watch(sharedUtilityProvider).getPath();
  }
  Ref ref;

  bool isMetadataDb = false;

  void setPath(String newValue) {
    ref.watch(sharedUtilityProvider).setPath(
          path: newValue,
        );
    state = ref.watch(sharedUtilityProvider).getPath();
  }
}
