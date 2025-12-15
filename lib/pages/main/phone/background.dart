import 'package:bujuan_music/utils/color_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_pixels/image_pixels.dart';

import '../provider.dart';

class PlayBackgroundStyle1 extends ConsumerWidget {
  final double? height;

  const PlayBackgroundStyle1({super.key, this.height});

  ///黑胶
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final artUrl = ref.watch(
      mediaItemProvider.select((value) => value.value?.artUri?.toString() ?? ''),
    );
    final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final size = MediaQuery.of(context).size;
    final h = height ?? size.height;

    Widget buildGradientFromImage(String url) {
      return ImagePixels(
        imageProvider: CachedNetworkImageProvider('$url?param=150y150'),
        builder: (context, img) {
          if (!img.hasImage) {
            return SizedBox(width: size.width, height: h);
          }
          final top = ColorUtils.blend(
            img.pixelColorAtAlignment!(Alignment.topCenter),
            scaffoldBackgroundColor,
            .65,
          );
          final mid = ColorUtils.blend(
            img.pixelColorAtAlignment!(Alignment.center),
            scaffoldBackgroundColor,
            .7,
          );
          final bottom = ColorUtils.blend(
            img.pixelColorAtAlignment!(Alignment.bottomCenter),
            scaffoldBackgroundColor,
            .75,
          );
          return SizedBox(
            width: size.width,
            height: h,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [top, mid, bottom],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          );
        },
      );
    }

    final fallback = SizedBox(
      width: size.width,
      height: h,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [scaffoldBackgroundColor, scaffoldBackgroundColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
    );

    return IgnorePointer(
      ignoring: true,
      child: RepaintBoundary(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          child: artUrl.isNotEmpty ? buildGradientFromImage(artUrl) : fallback,
        ),
      ),
    );
  }
}
