// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(newAlbum)
const newAlbumProvider = NewAlbumProvider._();

final class NewAlbumProvider
    extends
        $FunctionalProvider<AsyncValue<UserData>, UserData, FutureOr<UserData>>
    with $FutureModifier<UserData>, $FutureProvider<UserData> {
  const NewAlbumProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'newAlbumProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$newAlbumHash();

  @$internal
  @override
  $FutureProviderElement<UserData> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<UserData> create(Ref ref) {
    return newAlbum(ref);
  }
}

String _$newAlbumHash() => r'724f77c076ecff1de6e775ab85f2970e3df741a0';
