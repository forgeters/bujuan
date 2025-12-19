import 'package:nb_utils/nb_utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../common/values/app_config.dart';

part 'provider.g.dart';

@riverpod
class FloatBottomBarNotifier extends _$FloatBottomBarNotifier {
  @override
  bool build() => getBoolAsync(AppConfig.isFloatBottom, defaultValue: true);

  void toggleTheme() {
    state = !state;
  }
}
