import 'package:bujuan_music/utils/color_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_pixels/image_pixels.dart';

import '../provider.dart';

class PlayBackgroundStyle1 extends ConsumerWidget {
  final double? height;
  final Alignment? begin;
  final Alignment? end;

  const PlayBackgroundStyle1({super.key, this.height, this.begin, this.end});

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
        imageProvider: CachedNetworkImageProvider('$url?param=100y100'),
        builder: (context, img) {
          if (!img.hasImage) {
            return Container(width: size.width, height: h, color: scaffoldBackgroundColor);
          }
          final top = ColorUtils.blend(
            img.pixelColorAtAlignment!(Alignment.topCenter),
            scaffoldBackgroundColor,
            .65,
          );
          final mid = ColorUtils.blend(
            img.pixelColorAtAlignment!(Alignment.center),
            scaffoldBackgroundColor,
            begin != null ? 0.86 : 0.7,
          );
          final bottom = ColorUtils.blend(
            img.pixelColorAtAlignment!(Alignment.bottomCenter),
            scaffoldBackgroundColor,
            .75,
          );
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: begin != null ? [mid, scaffoldBackgroundColor] : [top, mid, bottom],
                begin: begin ?? Alignment.topCenter,
                end: end ?? Alignment.bottomCenter,
              ),
            ),
            width: size.width,
            height: h,
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
            begin: begin ?? Alignment.topCenter,
            end: end ?? Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(30.w),
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
