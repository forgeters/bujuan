import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BackdropView extends ConsumerWidget {
  static final ImageFilter _kBlurSigma8 = ImageFilter.blur(sigmaX: 3, sigmaY: 3);
  final BorderRadius? borderRadius;
  final BoxDecoration? decoration;
  final double? width;
  final double? height;
  final Widget child;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final BoxBorder? border;
  final Color? color;
  final Gradient? gradient;
  final bool blur;

  const BackdropView({
    super.key,
    this.padding,
    this.margin,
    this.border,
    this.color,
    this.gradient,
    this.borderRadius,
    this.decoration,
    this.width,
    this.height,
    this.blur = false,
    required this.child,
  });

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    var theme = Theme.of(context);
    final content = _buildContent(theme);
    if (!blur) return content;
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(0.w),
      child: BackdropFilter(filter: _kBlurSigma8, child: content),
    );
  }

  Widget _buildContent(ThemeData theme) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      decoration:
          decoration ??
          BoxDecoration(
            gradient: gradient,
            color: gradient != null
                ? null
                : color ?? (theme.scaffoldBackgroundColor.withAlpha(blur ? 180 : 255)),
            // 半透明背景
            borderRadius: borderRadius ?? BorderRadius.circular(30.w),
            border: border ?? Border.all(color: Colors.grey.withAlpha(10), width: 1.2.w),
            // boxShadow: [
            //   BoxShadow(
            //     color: Colors.grey.withAlpha(30), // 阴影颜色（很关键）
            //     blurRadius: 20,                    // 模糊程度
            //     spreadRadius: 0,                   // 扩散
            //     offset: const Offset(0, 8),        // Y 轴偏移
            //   ),
            // ],
          ),
      child: RepaintBoundary(child: child),
    );
  }
}
