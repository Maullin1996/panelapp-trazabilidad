// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stage4_load_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$stage4LoadHash() => r'9efa3c7b2cd67ee89bb2cb2883e3f98145fba81d';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [stage4Load].
@ProviderFor(stage4Load)
const stage4LoadProvider = Stage4LoadFamily();

/// See also [stage4Load].
class Stage4LoadFamily extends Family<AsyncValue<List<Stage4FormData>>> {
  /// See also [stage4Load].
  const Stage4LoadFamily();

  /// See also [stage4Load].
  Stage4LoadProvider call(String projectId) {
    return Stage4LoadProvider(projectId);
  }

  @override
  Stage4LoadProvider getProviderOverride(
    covariant Stage4LoadProvider provider,
  ) {
    return call(provider.projectId);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'stage4LoadProvider';
}

/// See also [stage4Load].
class Stage4LoadProvider
    extends AutoDisposeStreamProvider<List<Stage4FormData>> {
  /// See also [stage4Load].
  Stage4LoadProvider(String projectId)
    : this._internal(
        (ref) => stage4Load(ref as Stage4LoadRef, projectId),
        from: stage4LoadProvider,
        name: r'stage4LoadProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$stage4LoadHash,
        dependencies: Stage4LoadFamily._dependencies,
        allTransitiveDependencies: Stage4LoadFamily._allTransitiveDependencies,
        projectId: projectId,
      );

  Stage4LoadProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.projectId,
  }) : super.internal();

  final String projectId;

  @override
  Override overrideWith(
    Stream<List<Stage4FormData>> Function(Stage4LoadRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: Stage4LoadProvider._internal(
        (ref) => create(ref as Stage4LoadRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        projectId: projectId,
      ),
    );
  }

  @override
  AutoDisposeStreamProviderElement<List<Stage4FormData>> createElement() {
    return _Stage4LoadProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is Stage4LoadProvider && other.projectId == projectId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, projectId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin Stage4LoadRef on AutoDisposeStreamProviderRef<List<Stage4FormData>> {
  /// The parameter `projectId` of this provider.
  String get projectId;
}

class _Stage4LoadProviderElement
    extends AutoDisposeStreamProviderElement<List<Stage4FormData>>
    with Stage4LoadRef {
  _Stage4LoadProviderElement(super.provider);

  @override
  String get projectId => (origin as Stage4LoadProvider).projectId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
