import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:bujuan_music/common/local_proxy_service.dart';
import 'package:media_kit/media_kit.dart';

class BujuanMusicHandler extends BaseAudioHandler with QueueHandler, SeekHandler {
  // 私有构造函数
  BujuanMusicHandler._internal() {
    // 播放器状态同步到 audio_service
    _player.stream.playing.listen((playing) {
      playbackState.add(
        playbackState.value.copyWith(
          playing: playing,
          processingState: playing ? AudioProcessingState.ready : AudioProcessingState.buffering,
          systemActions: const {MediaAction.seek},
          androidCompactActionIndices: const [1, 2, 3],
          controls: [
            MediaControl.skipToPrevious,
            playing ? MediaControl.pause : MediaControl.play,
            MediaControl.skipToNext,
            MediaControl.stop,
          ],
          repeatMode: AudioServiceRepeatMode.all,
          shuffleMode: AudioServiceShuffleMode.none,
        ),
      );
    });
    _player.stream.position.listen((position) {
      playbackState.add(playbackState.value.copyWith(updatePosition: position));
    });

    _player.stream.playlist.listen((play) {
      print('播放列表发生变化-----------下标：${play.index}');
      playbackState.add(playbackState.value.copyWith(queueIndex: play.index));
      if (queue.value.isNotEmpty) {
        mediaItem.add(queue.value[play.index]);
      }
    });
    _player.stream.playlistMode.listen((mode) {
      playbackState.add(
        playbackState.value.copyWith(
          repeatMode: const {
            PlaylistMode.loop: AudioServiceRepeatMode.all,
            PlaylistMode.single: AudioServiceRepeatMode.none,
            PlaylistMode.none: AudioServiceRepeatMode.one,
          }[mode]!,
        ),
      );
    });

    _player.stream.shuffle.listen((shuffle) {
      playbackState.add(
        playbackState.value.copyWith(
          shuffleMode: shuffle ? AudioServiceShuffleMode.all : AudioServiceShuffleMode.none,
        ),
      );
    });
  }

  static final BujuanMusicHandler _instance = BujuanMusicHandler._internal();

  factory BujuanMusicHandler() => _instance;

  final Player _player = Player();


  init() async {
    AudioSession session = await AudioSession.instance;
    session.configure(const AudioSessionConfiguration.speech());
  }

  Player get player => _player;

  /// 更新播放列表
  @override
  Future<void> updateQueue(
    List<MediaItem> songs, {
    int index = 0,
    String queueName = '',
    bool save = true,
    Duration? position,
  }) async {
    if (songs.isEmpty) return;
    var playlist = <Media>[];
    if (queueTitle.value == queueName) {
      await _player.jump(index);
    } else {
      queueTitle.value = queueName;
      queue.add(songs);
      for (var song in songs) {
        playlist.add(Media(LocalProxyService().proxyUrl(song.id)));
      }
      Playlist list = Playlist(playlist, index: index);
      await _player.open(list);
    }
  }

  /// 播放
  @override
  Future<void> play() async {
    await _player.play();
  }

  @override
  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  /// 暂停
  @override
  Future<void> pause() async {
    await _player.pause();
  }

  /// 停止
  @override
  Future<void> stop() async {
    await _player.stop();
  }

  /// 播放 / 暂停切换
  Future<void> toggle() async {
    _player.playOrPause();
  }

  /// 下一首
  @override
  Future<void> skipToNext() async {
    await _player.next();
  }

  /// 上一首
  @override
  Future<void> skipToPrevious() async {
    await _player.previous();
  }

  /// 切换循环/随机模式（按你原来的逻辑改造，保证 shuffle 生效）
  Future<void> changeLoopMode() async {
    // if (_player.state.shuffle) {
    //   // 如果当前是 shuffle -> 关闭 shuffle，设为 all 循环
    //   await setShuffleEnabled(false);
    //   await _player.setPlaylistMode(PlaylistMode.loop);
    // } else {
    // 非 shuffle 情况下，按顺序切换 loopMode -> one -> shuffle
    var playlistMode = _player.state.playlistMode;
    if (playlistMode == PlaylistMode.loop) {
      await _player.setPlaylistMode(PlaylistMode.single);
    } else if (playlistMode == PlaylistMode.single) {
      await _player.setPlaylistMode(PlaylistMode.none);
    } else {
      await _player.setPlaylistMode(PlaylistMode.loop);
    }
    // }
  }

  /// 显式设置 shuffle 开关（如果你有独立按钮）
  Future<void> setShuffleEnabled(bool enabled) async {
    await _player.setShuffle(enabled);
  }

  /// 清理资源（如果需要）
  Future<void> dispose() async {
    await _player.dispose();
  }

  @override
  Future<void> onTaskRemoved() {
    dispose();
    print('任务被移除');
    return super.onTaskRemoved();
  }
}
