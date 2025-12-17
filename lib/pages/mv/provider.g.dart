// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(mvUrl)
const mvUrlProvider = MvUrlFamily._();

final class MvUrlProvider
    extends $FunctionalProvider<AsyncValue<MvData>, MvData, FutureOr<MvData>>
    with $FutureModifier<MvData>, $FutureProvider<MvData> {
  const MvUrlProvider._({
    required MvUrlFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'mvUrlProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$mvUrlHash();

  @override
  String toString() {
    return r'mvUrlProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<MvData> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<MvData> create(Ref ref) {
    final argument = this.argument as int;
    return mvUrl(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is MvUrlProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$mvUrlHash() => r'29f5fa63a4bc4defbd95bbf5ba0d1a831e65ade7';

final class MvUrlFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<MvData>, int> {
  const MvUrlFamily._()
    : super(
        retry: null,
        name: r'mvUrlProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MvUrlProvider call(int id) => MvUrlProvider._(argument: id, from: this);

  @override
  String toString() => r'mvUrlProvider';
}
