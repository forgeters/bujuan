// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(FloatBottomBarNotifier)
const floatBottomBarProvider = FloatBottomBarNotifierProvider._();

final class FloatBottomBarNotifierProvider
    extends $NotifierProvider<FloatBottomBarNotifier, bool> {
  const FloatBottomBarNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'floatBottomBarProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$floatBottomBarNotifierHash();

  @$internal
  @override
  FloatBottomBarNotifier create() => FloatBottomBarNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$floatBottomBarNotifierHash() =>
    r'0db1f8c840383d747b2810b7e612d99fb70052d9';

abstract class _$FloatBottomBarNotifier extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
