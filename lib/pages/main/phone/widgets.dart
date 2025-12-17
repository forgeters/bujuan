import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:bujuan_music/pages/play/play_page.dart';
import 'package:bujuan_music/pages/setting/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons_pro/hugeicons.dart';

import '../../../common/bujuan_music_handler_mediakit.dart';
import '../../../common/values/app_config.dart';
import '../../../widgets/cache_image.dart';
import '../../../widgets/we_slider/weslide.dart';
import '../../../widgets/we_slider/weslide_controller.dart';
import '../provider.dart';

class SliderWidget extends ConsumerWidget {
  final Widget child;

  const SliderWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Optimize MediaQuery calls
    final size = MediaQuery.sizeOf(context);
    final padding = MediaQuery.paddingOf(context);
    var bottom = (padding.bottom == 0 ? 10.w : padding.bottom) / (Platform.isAndroid ? 1 : 1.6);
    final double panelMinSize = 60.w + 74 + bottom;
    final double panelMaxSize = size.height;
    final panelController = GetIt.I<WeSlideController>(instanceName: 'panel');
    final footerController = GetIt.I<WeSlideController>(instanceName: 'footer');

    // Extract bottom navigation items (static, no need to rebuild)
    final bottomNavItems = AppConfig.bottomItems.map((e) {
      return NavigationDestination(
        icon: Icon(e.iconData),
        selectedIcon: Icon(e.activeIconData),
        label: e.title,
      );
    }).toList();

    return WeSlide(
      panelBorderRadiusBegin: 5.w,
      panelBorderRadiusEnd: 5.w,
      backgroundColor: Colors.transparent,
      panelMinSize: panelMinSize,
      panelMaxSize: panelMaxSize,
      panelWidth: size.width,
      hideFooter: true,
      footerController: footerController,
      controller: panelController,
      parallax: true,
      parallaxOffset: 0.01,
      body: child,
      panelBuilder: (scrollController, panelPosition) {
        return PlayPage(scrollController: scrollController);
      },
      panelHeader: const SongInfoBar(),
      footerHeight: 68 + bottom,
      footer: Consumer(
        builder: (context, ref, _) {
          final currentIndex = ref.watch(currentIndexProvider);
          var isFloat = ref.watch(floatBottomBarProvider);
          return MediaQuery.removePadding(
            context: context,
            removeTop: true,
            removeBottom: true,
            child: Container(
              margin: isFloat ? EdgeInsets.only(left: 8.w, right: 8.w, bottom: bottom) : null,
              child: ClipRRect(
                borderRadius: isFloat
                    ? BorderRadius.circular(20.w)
                    : BorderRadius.only(
                        topLeft: Radius.circular(20.w),
                        topRight: Radius.circular(20.w),
                      ),
                child: Material(
                  child: NavigationBar(
                    height: 68,
                    selectedIndex: currentIndex,
                    onDestinationSelected: (index) {
                      ref.read(currentIndexProvider.notifier).setIndex(index);
                      context.replace(AppConfig.bottomItems[index].path);
                    },
                    destinations: bottomNavItems,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// 全局播放条
class SongInfoBar extends ConsumerWidget {
  const SongInfoBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mediaItem = ref.watch(mediaItemProvider).value;
    Color scaffoldColor = Theme.of(context).scaffoldBackgroundColor;
    return _AnimatedSongInfoBar(mediaItem: mediaItem, scaffoldColor: scaffoldColor);
  }
}

class _AnimatedSongInfoBar extends StatelessWidget {
  final MediaItem? mediaItem;
  final Color scaffoldColor;

  const _AnimatedSongInfoBar({required this.mediaItem, required this.scaffoldColor});

  @override
  Widget build(BuildContext context) {
    final baseHeight = 60.w;
    final baseImage = 42.w;
    var backgroundColor = NavigationBarTheme.of(context).backgroundColor;
    return SizedBox(
      height: baseHeight,
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 7.w),
        elevation: 0,
        color: backgroundColor,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.w)),
        child: InkWell(
          onTap: () {
            final panelController = GetIt.I<WeSlideController>(instanceName: 'panel');
            panelController.show();
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 10),
              CachedImage(
                imageUrl: mediaItem?.artUri.toString() ?? '',
                width: baseImage,
                height: baseImage,
                pHeight: 100,
                pWidth: 100,
                borderRadius: baseImage / 2,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Wrap(
                  direction: Axis.vertical,
                  spacing: 2,
                  children: [
                    Text(
                      mediaItem?.title ?? '',
                      style: TextStyle(fontSize: 12.sp, fontWeight:FontWeight.w500,overflow: TextOverflow.ellipsis),
                      maxLines: 1,
                    ),
                    Text(
                      mediaItem?.artist ?? '',
                      style: TextStyle(fontSize: 12.sp, overflow: TextOverflow.ellipsis,color: Colors.grey),
                      maxLines: 1,
                    )
                  ],
                ),
              ),
              TogglePlayButton(22.sp),
              ControlButton(
                image: HugeIconsStroke.next,
                onTap: () => BujuanMusicHandler().skipToNext(),
              ),
              SizedBox(width: 10.w),
            ],
          ),
        ),
      ),
    );
  }
}

/// 控制播放暂停的按钮 指根据playing刷新ui
class TogglePlayButton extends ConsumerWidget {
  final double size;

  const TogglePlayButton(this.size, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var playing = ref.watch(playbackStateProvider.select((state) => state.value?.playing ?? false));
    return IconButton(
      onPressed: () => BujuanMusicHandler().toggle(),
      icon: Icon(playing ? HugeIconsStroke.pause : HugeIconsStroke.play, size: size),
    );
  }
}

class ControlButton extends StatelessWidget {
  final IconData image;
  final VoidCallback? onTap;
  final Color? color;

  const ControlButton({super.key, required this.image, this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(image, size: 22.sp, color: color),
      onPressed: onTap,
    );
  }
}

class DynamicPadding extends StatelessWidget {
  final bool hasBottom;

  const DynamicPadding({super.key, this.hasBottom = true});

  @override
  Widget build(BuildContext context) {
    var of2 = MediaQuery.of(context);
    return SizedBox(
      height: !hasBottom
          ? 66.w + of2.padding.bottom / (Platform.isAndroid ? 1 : 1.5)
          : 66.w + 78 + of2.padding.bottom / (Platform.isAndroid ? 1 : 1.5),
    );
  }
}
