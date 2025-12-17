import 'package:audio_service/audio_service.dart';
import 'package:bujuan_music/common/values/app_config.dart';
import 'package:bujuan_music_api/api/user/entity/user_info_entity.dart';
import 'package:bujuan_music_api/common/music_api.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../common/bujuan_music_handler_mediakit.dart';

part 'provider.g.dart';

@riverpod
class ThemeModeNotifier extends _$ThemeModeNotifier {
  @override
  ThemeMode build() =>
      getBoolAsync(AppConfig.isDarkTheme, defaultValue: false) ? ThemeMode.dark : ThemeMode.light;

  void setTheme(ThemeMode mode) {
    state = mode;
  }

  void toggleTheme() {
    state = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
  }
}

@riverpod
class BackgroundModeNotifier extends _$BackgroundModeNotifier {
  @override
  String build() => getStringAsync(AppConfig.backgroundPath, defaultValue: '');

  void changeBackground(String background) {
    state = background;
  }
}

@riverpod
class CurrentIndex extends _$CurrentIndex {
  @override
  int build() => 0; // 初始值

  void setIndex(int index) {
    state = index; // 修改值
  }
}

@riverpod
class BoxPanelDetailData extends _$BoxPanelDetailData {
  @override
  double build() => 0;

  void updatePanelDetail(double newValue) {
    state = newValue;
  }
}

@riverpod
class MediaImageColor extends _$MediaImageColor {
  @override
  Color build() => Color(0XFF1ED760).withAlpha(100);

  void updateColor(Color color) {
    state = color;
  }
}

@riverpod
class CurrentRouterPath extends _$CurrentRouterPath {
  @override
  String build() => '/';

  void updatePanelDetail(String newValue) {
    if (state != newValue) {
      state = newValue;
    }
  }
}

@riverpod
Stream<MediaItem?> mediaItem(Ref ref) {
  return BujuanMusicHandler().mediaItem.stream;
}

@riverpod
Stream<List<MediaItem>> mediaList(Ref ref) {
  return BujuanMusicHandler().queue.stream;
}

@riverpod
Stream<PlaybackState?> playbackState(Ref ref) {
  return BujuanMusicHandler().playbackState.stream;
}

@riverpod
Future<UserInfoEntity?> userInfo(Ref ref) async {
  return await BujuanMusicManager().userInfo();
}
