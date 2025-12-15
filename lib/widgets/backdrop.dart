import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BackdropView extends StatelessWidget {
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
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    if (!blur) {
      return _buildContent(theme);
    }
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(0.w),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8), //
        child: _buildContent(theme),
      ),
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
                : color ?? (theme.scaffoldBackgroundColor.withAlpha(blur?140:255)),
            // 半透明背景
            borderRadius: borderRadius ?? BorderRadius.circular(30.w),
            border: border ?? Border.all(color: Color(0XFF1ED760).withAlpha(10), width: 1.2.w),
          ),
      child: RepaintBoundary(child: child),
    );
  }
}
