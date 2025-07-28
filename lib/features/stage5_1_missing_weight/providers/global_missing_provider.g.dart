// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'global_missing_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$stage3GlobalSummaryHash() =>
    r'140379c0cfeff9324deafbc2cef77617fad49d2e';

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

/// See also [stage3GlobalSummary].
@ProviderFor(stage3GlobalSummary)
const stage3GlobalSummaryProvider = Stage3GlobalSummaryFamily();

/// See also [stage3GlobalSummary].
class Stage3GlobalSummaryFamily extends Family<Stage3GlobalSummary> {
  /// See also [stage3GlobalSummary].
  const Stage3GlobalSummaryFamily();

  /// See also [stage3GlobalSummary].
  Stage3GlobalSummaryProvider call(String projectId) {
    return Stage3GlobalSummaryProvider(projectId);
  }

  @override
  Stage3GlobalSummaryProvider getProviderOverride(
    covariant Stage3GlobalSummaryProvider provider,
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
  String? get name => r'stage3GlobalSummaryProvider';
}

/// See also [stage3GlobalSummary].
class Stage3GlobalSummaryProvider
    extends AutoDisposeProvider<Stage3GlobalSummary> {
  /// See also [stage3GlobalSummary].
  Stage3GlobalSummaryProvider(String projectId)
    : this._internal(
        (ref) => stage3GlobalSummary(ref as Stage3GlobalSummaryRef, projectId),
        from: stage3GlobalSummaryProvider,
        name: r'stage3GlobalSummaryProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$stage3GlobalSummaryHash,
        dependencies: Stage3GlobalSummaryFamily._dependencies,
        allTransitiveDependencies:
            Stage3GlobalSummaryFamily._allTransitiveDependencies,
        projectId: projectId,
      );

  Stage3GlobalSummaryProvider._internal(
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
    Stage3GlobalSummary Function(Stage3GlobalSummaryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: Stage3GlobalSummaryProvider._internal(
        (ref) => create(ref as Stage3GlobalSummaryRef),
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
  AutoDisposeProviderElement<Stage3GlobalSummary> createElement() {
    return _Stage3GlobalSummaryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is Stage3GlobalSummaryProvider && other.projectId == projectId;
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
mixin Stage3GlobalSummaryRef on AutoDisposeProviderRef<Stage3GlobalSummary> {
  /// The parameter `projectId` of this provider.
  String get projectId;
}

class _Stage3GlobalSummaryProviderElement
    extends AutoDisposeProviderElement<Stage3GlobalSummary>
    with Stage3GlobalSummaryRef {
  _Stage3GlobalSummaryProviderElement(super.provider);

  @override
  String get projectId => (origin as Stage3GlobalSummaryProvider).projectId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
