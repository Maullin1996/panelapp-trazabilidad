// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stage5_global_summary_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$stage5GlobalSummaryHash() =>
    r'620a5d9c6da91a312b9e2868f2d117b8e751fc87';

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

/// See also [stage5GlobalSummary].
@ProviderFor(stage5GlobalSummary)
const stage5GlobalSummaryProvider = Stage5GlobalSummaryFamily();

/// See also [stage5GlobalSummary].
class Stage5GlobalSummaryFamily extends Family<List<Stage5SummaryItem>> {
  /// See also [stage5GlobalSummary].
  const Stage5GlobalSummaryFamily();

  /// See also [stage5GlobalSummary].
  Stage5GlobalSummaryProvider call(String projectId) {
    return Stage5GlobalSummaryProvider(projectId);
  }

  @override
  Stage5GlobalSummaryProvider getProviderOverride(
    covariant Stage5GlobalSummaryProvider provider,
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
  String? get name => r'stage5GlobalSummaryProvider';
}

/// See also [stage5GlobalSummary].
class Stage5GlobalSummaryProvider
    extends AutoDisposeProvider<List<Stage5SummaryItem>> {
  /// See also [stage5GlobalSummary].
  Stage5GlobalSummaryProvider(String projectId)
    : this._internal(
        (ref) => stage5GlobalSummary(ref as Stage5GlobalSummaryRef, projectId),
        from: stage5GlobalSummaryProvider,
        name: r'stage5GlobalSummaryProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$stage5GlobalSummaryHash,
        dependencies: Stage5GlobalSummaryFamily._dependencies,
        allTransitiveDependencies:
            Stage5GlobalSummaryFamily._allTransitiveDependencies,
        projectId: projectId,
      );

  Stage5GlobalSummaryProvider._internal(
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
    List<Stage5SummaryItem> Function(Stage5GlobalSummaryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: Stage5GlobalSummaryProvider._internal(
        (ref) => create(ref as Stage5GlobalSummaryRef),
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
  AutoDisposeProviderElement<List<Stage5SummaryItem>> createElement() {
    return _Stage5GlobalSummaryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is Stage5GlobalSummaryProvider && other.projectId == projectId;
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
mixin Stage5GlobalSummaryRef
    on AutoDisposeProviderRef<List<Stage5SummaryItem>> {
  /// The parameter `projectId` of this provider.
  String get projectId;
}

class _Stage5GlobalSummaryProviderElement
    extends AutoDisposeProviderElement<List<Stage5SummaryItem>>
    with Stage5GlobalSummaryRef {
  _Stage5GlobalSummaryProviderElement(super.provider);

  @override
  String get projectId => (origin as Stage5GlobalSummaryProvider).projectId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
