// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(getMediaLyric)
const getMediaLyricProvider = GetMediaLyricProvider._();

final class GetMediaLyricProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<LyricLine>>,
          List<LyricLine>,
          FutureOr<List<LyricLine>>
        >
    with $FutureModifier<List<LyricLine>>, $FutureProvider<List<LyricLine>> {
  const GetMediaLyricProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getMediaLyricProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getMediaLyricHash();

  @$internal
  @override
  $FutureProviderElement<List<LyricLine>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<LyricLine>> create(Ref ref) {
    return getMediaLyric(ref);
  }
}

String _$getMediaLyricHash() => r'3acdacc012e893ac27865caa9dcb9674fcded3b2';
