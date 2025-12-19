import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../utils/color_utils.dart';
import '../provider.dart';

class PlayBackgroundStyle1 extends ConsumerWidget {
  final double? height;
  final BorderRadius? borderRadius;

  const PlayBackgroundStyle1({super.key, this.height, this.borderRadius});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scaffoldBg = Theme.of(context).scaffoldBackgroundColor;
    final size = MediaQuery.of(context).size;
    final h = height ?? size.height;

    final asyncScheme = ref.watch(dynamicColorProvider);

    Color bgColor = scaffoldBg;
    Object switchKey = 'default';

    asyncScheme.whenData((scheme) {
      bgColor = ColorUtils.blend(scheme.primary, scaffoldBg, .7);
      // 用 value，确保 key 稳定 & 可比较
      switchKey = scheme.primary.toARGB32();
    });

    return RepaintBoundary(
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,

        transitionBuilder: (child, animation) {
          return FadeTransition(opacity: animation, child: child);
        },

        child: ClipRRect(
          key: ValueKey(switchKey), // 🔥Switcher 真正感知变化的 key
          borderRadius: borderRadius ?? BorderRadius.zero,
          child: Container(width: size.width, height: h, color: bgColor),
        ),
      ),
    );
  }
}
