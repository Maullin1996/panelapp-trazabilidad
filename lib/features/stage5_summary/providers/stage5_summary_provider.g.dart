// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stage5_summary_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$stage5SummaryHash() => r'3d8e6eef79d2aebf3ba3f2403a698ae8be14a87a';

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

/// See also [stage5Summary].
@ProviderFor(stage5Summary)
const stage5SummaryProvider = Stage5SummaryFamily();

/// See also [stage5Summary].
class Stage5SummaryFamily extends Family<List<Stage5SummaryDay>> {
  /// See also [stage5Summary].
  const Stage5SummaryFamily();

  /// See also [stage5Summary].
  Stage5SummaryProvider call(String projectId) {
    return Stage5SummaryProvider(projectId);
  }

  @override
  Stage5SummaryProvider getProviderOverride(
    covariant Stage5SummaryProvider provider,
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
  String? get name => r'stage5SummaryProvider';
}

/// See also [stage5Summary].
class Stage5SummaryProvider
    extends AutoDisposeProvider<List<Stage5SummaryDay>> {
  /// See also [stage5Summary].
  Stage5SummaryProvider(String projectId)
    : this._internal(
        (ref) => stage5Summary(ref as Stage5SummaryRef, projectId),
        from: stage5SummaryProvider,
        name: r'stage5SummaryProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$stage5SummaryHash,
        dependencies: Stage5SummaryFamily._dependencies,
        allTransitiveDependencies:
            Stage5SummaryFamily._allTransitiveDependencies,
        projectId: projectId,
      );

  Stage5SummaryProvider._internal(
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
    List<Stage5SummaryDay> Function(Stage5SummaryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: Stage5SummaryProvider._internal(
        (ref) => create(ref as Stage5SummaryRef),
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
  AutoDisposeProviderElement<List<Stage5SummaryDay>> createElement() {
    return _Stage5SummaryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is Stage5SummaryProvider && other.projectId == projectId;
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
mixin Stage5SummaryRef on AutoDisposeProviderRef<List<Stage5SummaryDay>> {
  /// The parameter `projectId` of this provider.
  String get projectId;
}

class _Stage5SummaryProviderElement
    extends AutoDisposeProviderElement<List<Stage5SummaryDay>>
    with Stage5SummaryRef {
  _Stage5SummaryProviderElement(super.provider);

  @override
  String get projectId => (origin as Stage5SummaryProvider).projectId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
