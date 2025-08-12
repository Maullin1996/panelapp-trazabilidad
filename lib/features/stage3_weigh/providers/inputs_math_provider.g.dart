// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inputs_math_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$loadSummaryHash() => r'eb693ce9cff87dbffcee02ca081c66415cfbaa58';

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

/// See also [loadSummary].
@ProviderFor(loadSummary)
const loadSummaryProvider = LoadSummaryFamily();

/// See also [loadSummary].
class LoadSummaryFamily extends Family<LoadSummary> {
  /// See also [loadSummary].
  const LoadSummaryFamily();

  /// See also [loadSummary].
  LoadSummaryProvider call(String projectId, int index) {
    return LoadSummaryProvider(projectId, index);
  }

  @override
  LoadSummaryProvider getProviderOverride(
    covariant LoadSummaryProvider provider,
  ) {
    return call(provider.projectId, provider.index);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'loadSummaryProvider';
}

/// See also [loadSummary].
class LoadSummaryProvider extends AutoDisposeProvider<LoadSummary> {
  /// See also [loadSummary].
  LoadSummaryProvider(String projectId, int index)
    : this._internal(
        (ref) => loadSummary(ref as LoadSummaryRef, projectId, index),
        from: loadSummaryProvider,
        name: r'loadSummaryProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$loadSummaryHash,
        dependencies: LoadSummaryFamily._dependencies,
        allTransitiveDependencies: LoadSummaryFamily._allTransitiveDependencies,
        projectId: projectId,
        index: index,
      );

  LoadSummaryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.projectId,
    required this.index,
  }) : super.internal();

  final String projectId;
  final int index;

  @override
  Override overrideWith(LoadSummary Function(LoadSummaryRef provider) create) {
    return ProviderOverride(
      origin: this,
      override: LoadSummaryProvider._internal(
        (ref) => create(ref as LoadSummaryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        projectId: projectId,
        index: index,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<LoadSummary> createElement() {
    return _LoadSummaryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is LoadSummaryProvider &&
        other.projectId == projectId &&
        other.index == index;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, projectId.hashCode);
    hash = _SystemHash.combine(hash, index.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin LoadSummaryRef on AutoDisposeProviderRef<LoadSummary> {
  /// The parameter `projectId` of this provider.
  String get projectId;

  /// The parameter `index` of this provider.
  int get index;
}

class _LoadSummaryProviderElement
    extends AutoDisposeProviderElement<LoadSummary>
    with LoadSummaryRef {
  _LoadSummaryProviderElement(super.provider);

  @override
  String get projectId => (origin as LoadSummaryProvider).projectId;
  @override
  int get index => (origin as LoadSummaryProvider).index;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
