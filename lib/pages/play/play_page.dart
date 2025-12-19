import 'package:audio_service/audio_service.dart';
import 'package:bujuan_music/utils/time_utils.dart';
import 'package:bujuan_music/widgets/cache_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:hugeicons_pro/hugeicons.dart';
import '../../common/bujuan_music_handler.dart';
import '../../widgets/wave.dart';
import '../../widgets/we_slider/weslide_controller.dart';
import '../main/phone/background.dart';
import '../main/phone/widgets.dart';
import '../main/provider.dart';

class PlayPage extends StatelessWidget {
  final ScrollController scrollController;

  const PlayPage({super.key, required this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(bottom: 0, child: const PlayBackgroundStyle1()),
          ListView(
            controller: scrollController,
            children: [
              RepaintBoundary(child: const MusicControlsSection()),
              // SizedBox(
              //   height: 500.w,
              //   child: LyricWidget(),
              // )
            ],
          ),
        ],
      ),
    );
  }
}

class MusicControlsSection extends StatelessWidget {
  const MusicControlsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final panelController = GetIt.I<WeSlideController>(instanceName: 'panel');
    return Column(
      children: [
        SafeArea(
          bottom: false,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    panelController.hide();
                  },
                  icon: Icon(HugeIconsStroke.arrowDown01, size: 26.sp),
                ),
              ],
            ),
          ),
        ),
        AlbumWidget(),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 30.w),
          child: MusicProgressBar(),
        ),
        SizedBox(height: 45.w),
        const PlaybackControls(),
      ],
    );
  }
}

/// 音乐进度条
class MusicProgressBar extends StatelessWidget {
  const MusicProgressBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 30.w,
          child: const RepaintBoundary(child: _WaveformConsumer()),
        ),
        SizedBox(height: 8.w),
        RepaintBoundary(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [_CurrentPositionText(), _DurationText()],
          ),
        ),
      ],
    );
  }
}

class _WaveformConsumer extends ConsumerWidget {
  const _WaveformConsumer();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final position = ref.watch(
      playbackStateProvider.select((state) => state.value?.updatePosition.inMilliseconds ?? 0),
    );
    final duration = ref.watch(
      mediaItemProvider.select((state) => state.value?.duration?.inMilliseconds ?? 0),
    );
    final progress = (duration > 0) ? position / duration : 0.0;

    return WaveformProgressWidget(
      progress: progress,
      min: 0,
      max: 1,
      playedColor: IconTheme.of(context).color ?? Colors.grey,
      unplayedColor: (IconTheme.of(context).color ?? Colors.grey).withAlpha(180),
      onChangeEnd: (value) {
        final seekTo = Duration(milliseconds: (duration * value).toInt());
        BujuanMusicHandler().seek(seekTo);
      },
    );
  }
}

class _CurrentPositionText extends ConsumerWidget {
  const _CurrentPositionText();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final position = ref.watch(
      playbackStateProvider.select((state) => state.value?.updatePosition.inMilliseconds ?? 0),
    );
    final positionDuration = TimeUtils.formatDuration(position ~/ 1000);
    return Text(
      positionDuration,
      style: TextStyle(fontSize: 14.sp, color: Colors.grey),
    );
  }
}

class _DurationText extends ConsumerWidget {
  const _DurationText();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final duration = ref.watch(
      mediaItemProvider.select((state) => state.value?.duration?.inMilliseconds ?? 0),
    );
    final durationDuration = TimeUtils.formatDuration(duration ~/ 1000);
    return Text(
      durationDuration,
      style: TextStyle(fontSize: 14.sp, color: Colors.grey),
    );
  }
}

class PlaybackControls extends StatelessWidget {
  const PlaybackControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(width: 25.w),
        const ControlButton(image: HugeIconsSolid.favourite, color: Colors.red),
        SizedBox(width: 15.w),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ControlButton(
                image: HugeIconsStroke.previous,
                onTap: () => BujuanMusicHandler().skipToPrevious(),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.withAlpha(120),
                  borderRadius: BorderRadius.circular(25.w),
                ),
                width: 48.w,
                height: 48.w,
                child: TogglePlayButton(22.sp),
              ),
              ControlButton(
                image: HugeIconsStroke.next,
                onTap: () => BujuanMusicHandler().skipToNext(),
              ),
            ],
          ),
        ),
        SizedBox(width: 15.w),
        // Only loop mode button needs to watch provider
        Consumer(
          builder: (context, ref, child) {
            final loopMode = ref.watch(playbackStateProvider.select((e) => e.value?.repeatMode));
            return ControlButton(
              image: loopMode == AudioServiceRepeatMode.none
                  ? HugeIconsStroke.repeatOff
                  : loopMode == AudioServiceRepeatMode.all
                  ? HugeIconsStroke.repeat
                  : HugeIconsStroke.repeatOne02,
              onTap: () {
                BujuanMusicHandler().changeLoopMode();
              },
            );
          },
        ),
        SizedBox(width: 25.w),
      ],
    );
  }
}

class AlbumWidget extends ConsumerWidget {
  const AlbumWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final media = ref.watch(mediaItemProvider).value;
    return Column(
      children: [
        RepaintBoundary(
          child: CachedImage(
            imageUrl: media?.artUri?.toString() ?? '',
            width: 280.w,
            height: 280.w,
            pWidth: 500,
            pHeight: 500,
            borderRadius: 30.w,
          ),
        ),
        SizedBox(height: 40.w),
        Container(
          height: 35.w,
          padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 0.w),
          child: Text(
            media?.title ?? '',
            style: TextStyle(
              fontSize: 18.sp,
              overflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
          ),
        ),
        Container(
          height: 25.w,
          padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 0.w),
          child: Text(
            media?.artist ?? '',
            style: TextStyle(fontSize: 12.sp, color: Colors.grey, overflow: TextOverflow.ellipsis),
            maxLines: 1,
          ),
        ),
        SizedBox(height: 40.w),
      ],
    );
  }
}
