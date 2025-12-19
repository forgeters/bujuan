import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'weslide_controller.dart';

/// 一个可在主体内容上方滑出的面板容器组件
// ignore: must_be_immutable
class WeSlide extends StatefulWidget {
  /// 底部区域（如 `BottomNavigationBar`）
  final Widget? footer;

  /// 顶部区域（如 `AppBar`）
  final Widget? appBar;

  /// 主体内容（被面板覆盖的部分）
  final Widget body;

  /// 面板内容（滑动到主体内容之上）
  final Widget? panel;

  /// Builds a scrollable panel and provides a [ScrollController]
  /// and current panel position (0.0~1.0). If both [panel] and
  /// [panelBuilder] are provided, [panelBuilder] takes precedence.
  final Widget Function(ScrollController controller, double panelPosition)?
  panelBuilder;

  /// 面板头部（位于面板内容之上）
  final Widget? panelHeader;

  /// 面板最小高度（收起时露出的高度），默认 150.0；设为 0 可完全隐藏
  final double panelMinSize;

  /// 面板最大高度（完全展开的高度），默认 400.0；要覆盖全屏可设为屏幕高度
  final double panelMaxSize;

  /// 面板宽度，默认等于屏幕宽度
  final double? panelWidth;

  /// 面板圆角起始值（用于面板滑动过程的圆角动画），默认 0.0
  final double panelBorderRadiusBegin;

  /// 面板圆角结束值（用于面板滑动过程的圆角动画），默认 0.0
  final double panelBorderRadiusEnd;

  /// 主体圆角起始值（用于面板滑动过程对主体的圆角动画），默认 0.0
  final double bodyBorderRadiusBegin;

  /// 主体圆角结束值（用于面板滑动过程对主体的圆角动画），默认 0.0
  final double bodyBorderRadiusEnd;

  /// 主体宽度，默认等于屏幕宽度
  final double? bodyWidth;

  /// 面板滑动时的视差偏移系数，默认 0.1
  final double parallaxOffset;

  /// 底部区域高度，默认 60.0
  final double footerHeight;

  /// 顶部区域高度，默认 80.0
  final double appBarHeight;

  /// 面板与主体之间的遮罩不透明度
  final double overlayOpacity;

  /// 高斯模糊强度
  final double blurSigma;

  /// 主体缩放起始值，默认 1.0
  final double transformScaleBegin;

  /// 主体缩放结束值，默认 0.85
  final double transformScaleEnd;

  /// 遮罩颜色，默认 `Colors.black`
  final Color overlayColor;

  /// 模糊颜色，默认 `Colors.black`
  final Color blurColor;

  /// 背景颜色，默认 `Colors.black`，建议与主体一致
  final Color backgroundColor;

  /// 是否隐藏底部区域，默认 `true`
  final bool hideFooter;

  /// 是否隐藏面板头部，默认 `true`
  final bool hidePanelHeader;

  /// 是否开启视差效果，默认 `false`
  final bool parallax;

  /// 是否开启主体缩放效果，默认 `false`
  final bool transformScale;

  /// 是否隐藏顶部区域（例如 AppBar），默认 `true`
  final bool hideAppBar;

  /// 面板打开时，点击遮罩是否关闭面板
  final bool isDismissible;

  /// 是否允许通过面板本身上滑打开，默认 `true`
  final bool isUpSlide;

  /// 面板头部淡入淡出序列
  final List<TweenSequenceItem<double>> fadeSequence;

  /// 动画时长，默认 300ms
  final Duration animateDuration;

  /// 面板控制器：打开/关闭/状态监听等
  WeSlideController? controller;

  /// 底部区域的附加控制器
  WeSlideController? footerController;

  /// 拖拽响应灵敏度（数值越大越跟手）
  final double dragSensitivity;

  /// WeSlide Constructor
  WeSlide({
    super.key,
    this.footer,
    this.appBar,
    required this.body,
    this.panel,
    this.panelBuilder,
    this.panelHeader,
    this.panelMinSize = 150.0,
    this.panelMaxSize = 400.0,
    this.panelWidth,
    this.panelBorderRadiusBegin = 0.0,
    this.panelBorderRadiusEnd = 0.0,
    this.bodyBorderRadiusBegin = 0.0,
    this.bodyBorderRadiusEnd = 0.0,
    this.bodyWidth,
    this.transformScaleBegin = 1.0,
    this.transformScaleEnd = 0.85,
    this.parallaxOffset = 0.1,
    this.overlayOpacity = 0.0,
    this.blurSigma = 5.0,
    this.overlayColor = Colors.black,
    this.blurColor = Colors.black,
    this.backgroundColor = Colors.black,
    this.footerHeight = 60.0,
    this.appBarHeight = 80.0,
    this.hideFooter = true,
    this.hidePanelHeader = true,
    this.parallax = false,
    this.transformScale = false,
    this.hideAppBar = true,
    this.isDismissible = true,
    this.isUpSlide = true,
    List<TweenSequenceItem<double>>? fadeSequence,
    this.animateDuration = const Duration(milliseconds: 300),
    this.controller,
    this.footerController,
    this.dragSensitivity = 2.0,
  }) : /*assert(body != null, 'body could not be null'),*/
       assert(panelMinSize >= 0.0, 'panelMinSize cannot be negative'),
       assert(footerHeight >= 0.0, 'footerHeight cannot be negative'),
       assert(appBarHeight >= 0.0, 'appBarHeight cannot be negative'),
       assert(panel != null || panelBuilder != null, 'panel could not be null'),
       assert(
         panelMaxSize >= panelMinSize,
         'panelMaxSize cannot be less than panelMinSize',
       ),
       fadeSequence =
           fadeSequence ??
           [
             TweenSequenceItem<double>(
               weight: 1.0,
               tween: Tween(begin: 1, end: 0),
             ),
             TweenSequenceItem<double>(
               weight: 8.0,
               tween: Tween(begin: 0, end: 0),
             ),
           ] {
    assert(dragSensitivity > 0, 'dragSensitivity must be greater than zero');
    if (controller == null) {
      // ignore: unnecessary_this
      this.controller = WeSlideController();
    }
    if (footerController == null) {
      // ignore: unnecessary_this
      this.footerController = WeSlideController(initial: true);
    }
  }

  @override
  WeSlideState createState() => WeSlideState();
}

class WeSlideState extends State<WeSlide> with TickerProviderStateMixin {
  // Main Animation Controller
  late AnimationController _ac;

  // Panel Border Radius Effect[Tween]
  late Animation<double> _panelBorderRadius;

  // Scale Animation Effect [Tween]
  late Animation<double> _scaleAnimation;

  // PanelHeader animation Effect [Tween]
  late Animation<double> _fadeAnimation;

  // Footer Animation Controller
  late AnimationController _acFooter;

  // Scroll controller for scrollable panel when using [panelBuilder]
  ScrollController? _panelScrollController;
  bool _shouldCapturePanelDrag = true; // only capture when inner list at top
  bool _activeIntercept = false; // if current gesture is handled by panel
  late Listenable _mergedAnimations;
  bool _closingInProgress = false;
  final List<double> _dySamples = <double>[];
  final List<Duration> _timeSamples = <Duration>[];

  // Get current controller
  WeSlideController get _effectiveController => widget.controller!;

  WeSlideController get _effectiveFooterController => widget.footerController!;

  // Check if panel is visible
  bool get _isPanelVisible =>
      _ac.status == AnimationStatus.completed ||
      _ac.status == AnimationStatus.forward;

  bool get _isFooterVisible =>
      _acFooter.status == AnimationStatus.completed ||
      _acFooter.status == AnimationStatus.forward;
  List<TweenSequenceItem<double>> panelFadeSequence = [
    TweenSequenceItem<double>(weight: 1.0, tween: Tween(begin: 0, end: 0)),
    TweenSequenceItem<double>(weight: 9.0, tween: Tween(begin: 1, end: 1)),
  ];

  @override
  void initState() {
    // Subscribe to animated when value change
    _effectiveController.addListener(_animatedPanel);
    _effectiveFooterController.addListener(_animatedFooter);
    // Animation controller;
    _ac = AnimationController(
      vsync: this,
      duration: widget.animateDuration,
      value: _effectiveController.isOpened ? 1 : 0,
    );
    _acFooter = AnimationController(
      vsync: this,
      duration: widget.animateDuration,
      value: _effectiveFooterController.isOpened ? 1 : 0,
    ); // show by default
    // panel Border radius animation

    _panelBorderRadius = Tween<double>(
      begin: widget.panelBorderRadiusBegin,
      end: widget.panelBorderRadiusEnd,
    ).animate(_ac);
    // body border radius animation

    _scaleAnimation = Tween<double>(
      begin: widget.transformScaleBegin,
      end: widget.transformScaleEnd,
    ).animate(_ac);
    // Fade Animation sequence
    _fadeAnimation = TweenSequence(widget.fadeSequence).animate(_ac);

    if (widget.panelBuilder != null) {
      _panelScrollController = ScrollController();
      _panelScrollController!.addListener(_syncScrollCaptureState);
    }

    _mergedAnimations = Listenable.merge([_ac, _acFooter]);

    // Super Init State
    super.initState();
  }

  /// Required for resubscribing when hot reload occurs [ValueNotifier]
  @override
  void didUpdateWidget(WeSlide oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.controller?.removeListener(_animatedPanel);
    widget.controller?.addListener(_animatedPanel);
    if (oldWidget.panelBuilder == null &&
        widget.panelBuilder != null &&
        _panelScrollController == null) {
      _panelScrollController = ScrollController();
      _panelScrollController!.addListener(_syncScrollCaptureState);
    }
    if (oldWidget.panelBuilder != null && widget.panelBuilder == null) {
      _panelScrollController?.removeListener(_syncScrollCaptureState);
      _panelScrollController?.dispose();
      _panelScrollController = null;
      _shouldCapturePanelDrag = true;
    }
  }

  /// Animate the panel [ValueNotifier]
  void _animatedPanel() {
    if (_effectiveController.value != _isPanelVisible) {
      _ac.fling(velocity: _isPanelVisible ? -2.0 : 2.0);
    }
  }

  void _syncScrollCaptureState() {
    if (_panelScrollController == null || !_panelScrollController!.hasClients)
      return;
    final pos = _panelScrollController!.position;
    final atTop = pos.pixels <= pos.minScrollExtent + 0.5;
    _shouldCapturePanelDrag = atTop;
  }

  /// Animate the footer [ValueNotifier]
  void _animatedFooter() {
    if (_effectiveFooterController.value != _isFooterVisible) {
      _acFooter.fling(velocity: _isFooterVisible ? -2.0 : 2.0);
    }
  }

  /// Dispose
  @override
  void dispose() {
    ///Animation Controller
    _ac.dispose();
    _acFooter.dispose();
    _panelScrollController?.removeListener(_syncScrollCaptureState);
    _panelScrollController?.dispose();

    /// ValueNotifier
    // _effectiveController.dispose();
    // _effectiveFooterController.dispose();
    super.dispose();
  }

  /// Gesture Vertical Update [GestureDetector]
  void _handleVerticalUpdate(DragUpdateDetails updateDetails) {
    var delta = updateDetails.primaryDelta!;
    var fractionDragged = delta / widget.panelMaxSize;
    if (widget.isUpSlide == false && _effectiveController.value == false) {
      return;
    }
    // Only handle downward drag when inner list at top; upward drag should be left to inner list
    if (widget.panelBuilder != null) {
      if (!_shouldCapturePanelDrag) {
        _activeIntercept = false;
        return;
      }
      if (delta < 0) {
        // upward drag -> let inner list handle
        _activeIntercept = false;
        return;
      }
    }
    _activeIntercept = true;
    _ac.value -= widget.dragSensitivity * fractionDragged;
  }

  /// Gesture Vertical End [GestureDetector]
  void _handleVerticalEnd(DragEndDetails endDetails) {
    var velocity = endDetails.primaryVelocity!;
    if (widget.panelBuilder != null && !_activeIntercept) {
      return;
    }
    if (velocity > 0.0) {
      _ac.reverse().then((x) {
        _effectiveController.value = false;
      });
    } else if (velocity < 0.0) {
      if (widget.isUpSlide) {
        _ac.forward().then((x) {
          _effectiveController.value = true;
        });
      }
    } else if (_ac.value >= 0.5 && endDetails.primaryVelocity == 0.0) {
      _ac.forward().then((x) {
        _effectiveController.value = true;
      });
    } else {
      _ac.reverse().then((x) {
        _effectiveController.value = false;
      });
    }
    _activeIntercept = false;
  }

  //Get Panel size
  double _getPanelSize() {
    var size = 0.0;
    /* If footer is visible*/
    if (!widget.hideFooter && widget.footer != null) {
      size += widget.footerHeight;
    }
    /* If appbar is visible*/
    if (!widget.hideAppBar && widget.appBar != null) {
      size += widget.appBarHeight;
    }

    return size;
  }

  /* Get panel maxsize location*/
  double _getPanelLocation() {
    var location = widget.panelMaxSize;
    if (widget.appBar != null && !widget.hideAppBar) {
      location += -widget.appBarHeight;
    }
    return location;
  }

  double _getFooterOffset() {
    var height = widget.footerHeight;
    final offset = widget.hideFooter
        ? (_ac.value * -height + (1 - _acFooter.value) * -height)
        : .0;
    if (offset < -height) {
      return -height;
    } else if (offset > height) {
      return height;
    } else {
      return offset;
    }
  }

  /* Get Body location*/
  double _getBodyLocation() {
    var location = 0.0;

    /* if appbar */
    if (widget.appBar != null) {
      location += widget.appBarHeight;
    }

    /* if paralax*/
    if (widget.parallax) {
      location +=
          _ac.value *
          (widget.panelMaxSize - widget.panelMinSize) *
          -widget.parallaxOffset;
    }
    return location;
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final bottom = MediaQuery.of(context).padding.bottom <= 0
        ? 8.w
        : MediaQuery.of(context).padding.bottom /
              (Platform.isAndroid ? 1.2 : 1.6);
    final double panelPadBase = 60.w; // 面板内容顶部基础间距常量

    return Container(
      height: height,
      color: widget.backgroundColor, // Same as body,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          /** Body widget **/
          AnimatedBuilder(
            animation: Listenable.merge([_ac, _acFooter]),
            builder: (context, child) {
              return Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 0,
                child: Transform.translate(
                  offset: Offset(0, _getBodyLocation()),
                  child: Transform.scale(
                    scale: widget.transformScale ? _scaleAnimation.value : 1.0,
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      height: height,
                      width: widget.bodyWidth ?? width,
                      child: RepaintBoundary(child: child),
                    ),
                  ),
                ),
              );
            },
            child: widget.body,
          ),
          /** Dismiss Panel **/
          ValueListenableBuilder(
            valueListenable: _effectiveController,
            builder: (_, __, ___) {
              if (_effectiveController.isOpened && widget.isDismissible) {
                return GestureDetector(
                  onTap: _effectiveController.hide,
                  child: Container(color: Colors.transparent),
                );
              }
              return const SizedBox();
            },
          ),
          /** Panel widget **/
          AnimatedBuilder(
            animation: _mergedAnimations,
            builder: (_, child) {
              // Calculate panel vertical offset manually to avoid object allocation (Tween)
              final double minSize =
                  widget.panelMinSize +
                  _getFooterOffset() +
                  (1 - _acFooter.value) * bottom;
              final double maxSize = _getPanelLocation();
              // Interpolate between closed offset (panelMaxSize - minSize) and open offset (panelMaxSize - maxSize)
              final double closedOffset = widget.panelMaxSize - minSize;
              final double openOffset = widget.panelMaxSize - maxSize;
              final double currentOffset =
                  closedOffset * (1 - _ac.value) + openOffset * _ac.value;

              return Transform.translate(
                offset: Offset(0, currentOffset),
                child: Listener(
                  onPointerDown: (e) {
                    _activeIntercept = false;
                    _dySamples.clear();
                    _timeSamples.clear();
                  },
                  onPointerMove: (e) {
                    if (widget.panelBuilder != null) {
                      _dySamples.add(e.delta.dy);
                      _timeSamples.add(e.timeStamp);
                      if (_dySamples.length > 5) {
                        _dySamples.removeAt(0);
                        _timeSamples.removeAt(0);
                      }
                      final atTop = _shouldCapturePanelDrag;
                      final isOpen = _ac.value >= 1.0 - 1e-3;
                      final isClosed = _ac.value <= 1e-3;
                      if (e.delta.dy < 0) {
                        // upward: open panel if not fully open
                        if (!isOpen) {
                          _activeIntercept = true;
                          final fractionDragged =
                              e.delta.dy / widget.panelMaxSize;
                          _ac.value -= widget.dragSensitivity * fractionDragged;
                          return;
                        }
                        _activeIntercept = false;
                        return;
                      } else if (e.delta.dy > 0) {
                        // downward: close panel only when inner list at top
                        if (atTop && !isClosed) {
                          _activeIntercept = true;
                          final fractionDragged =
                              e.delta.dy / widget.panelMaxSize;
                          _ac.value -= widget.dragSensitivity * fractionDragged;
                          return;
                        }
                        _activeIntercept = false;
                        return;
                      }
                    }
                  },
                  onPointerUp: (e) {
                    if (widget.panelBuilder != null) {
                      if (!_activeIntercept) return;
                      double velocity = 0.0;
                      if (_dySamples.isNotEmpty) {
                        final double dySum = _dySamples.fold(
                          0.0,
                          (a, b) => a + b,
                        );
                        final Duration start = _timeSamples.first;
                        final Duration end = _timeSamples.last;
                        final int dtMs = (end - start).inMilliseconds.abs();
                        if (dtMs > 0) velocity = (dySum / dtMs) * 1000.0;
                      }
                      const double flingThreshold = 700.0;
                      if (velocity > flingThreshold) {
                        _closingInProgress = true;
                        _ac
                            .reverse()
                            .then((_) => _effectiveController.value = false)
                            .whenComplete(() => _closingInProgress = false);
                      } else if (velocity < -flingThreshold) {
                        _ac.forward().then(
                          (_) => _effectiveController.value = true,
                        );
                      } else {
                        if (_ac.value >= 0.5) {
                          _ac.forward().then(
                            (_) => _effectiveController.value = true,
                          );
                        } else {
                          _closingInProgress = true;
                          _ac
                              .reverse()
                              .then((_) => _effectiveController.value = false)
                              .whenComplete(() => _closingInProgress = false);
                        }
                      }
                      _activeIntercept = false;
                      return;
                    }
                  },
                  child: SizedBox(
                    height: widget.panelMaxSize,
                    width: widget.panelWidth ?? width,
                    child: Builder(
                      builder: (context) {
                        final radius = _panelBorderRadius.value;
                        if (radius <= 0) {
                          return RepaintBoundary(
                            child: widget.panelBuilder != null
                                ? child
                                : GestureDetector(
                                    onVerticalDragUpdate: (details) =>
                                        _handleVerticalUpdate(details),
                                    onVerticalDragEnd: (details) =>
                                        _handleVerticalEnd(details),
                                    child: child,
                                  ),
                          );
                        }
                        return ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(radius),
                            topRight: Radius.circular(radius),
                          ),
                          child: RepaintBoundary(
                            child: widget.panelBuilder != null
                                ? child
                                : GestureDetector(
                                    onVerticalDragUpdate: (details) =>
                                        _handleVerticalUpdate(details),
                                    onVerticalDragEnd: (details) =>
                                        _handleVerticalEnd(details),
                                    child: child,
                                  ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
            child: Stack(
              children: <Widget>[
                /** Panel widget **/
                SizedBox(
                  height: height - _getPanelSize(),
                  child: AnimatedBuilder(
                    animation: _mergedAnimations,
                    builder: (context, child) {
                      // Lazy rendering: if panel is closed, do not render body
                      // if (_ac.value <= 1e-1 &&
                      //     _ac.status != AnimationStatus.forward) {
                      //   return const SizedBox.shrink();
                      // }

                      final double dynamicTop =
                          (panelPadBase + (1 - _acFooter.value) * widget.panelMinSize) *
                          (1 - _ac.value);
                      return Transform.translate(
                        offset: Offset(0, dynamicTop),
                        child: child,
                      );
                    },
                    child: widget.panelBuilder != null
                        ? PrimaryScrollController(
                            controller: _panelScrollController!,
                            child: IgnorePointer(
                              ignoring: _closingInProgress,
                              child: widget.panelBuilder!(
                                _panelScrollController!,
                                _ac.value,
                              ),
                            ),
                          )
                        : widget.panel!,
                  ),
                ),
                /** Panel Header widget **/
                widget.panelHeader != null && widget.hidePanelHeader
                    ? FadeTransition(
                        opacity: _fadeAnimation,
                        child: RepaintBoundary(
                          child: ValueListenableBuilder(
                            valueListenable: _effectiveController,
                            builder: (_, __, ___) {
                              return IgnorePointer(
                                ignoring:
                                    _effectiveController.value &&
                                    widget.hidePanelHeader,
                                child: widget.panelHeader,
                              );
                            },
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
                /** panelHeader widget is null ?**/
                widget.panelHeader != null && !widget.hidePanelHeader
                    ? widget.panelHeader!
                    : const SizedBox.shrink(),
                // PanelHeader
              ],
            ),
          ),

          SizedBox(height: bottom),
          // Footer Widget
          widget.footer != null
              ? AnimatedBuilder(
                  animation: _mergedAnimations,
                  builder: (context, child) {
                    return Positioned(
                      height: widget.footerHeight,
                      bottom: 0,
                      width: width,
                      child: Transform.translate(
                        offset: Offset(0, -_getFooterOffset()),
                        child: RepaintBoundary(child: widget.footer!),
                      ),
                    );
                  },
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
