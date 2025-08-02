// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stage4_ui_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$stage4UiHash() => r'29ac163ee6e50531376c1036cc96a71085b8360d';

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

abstract class _$Stage4Ui extends BuildlessAutoDisposeNotifier<Stage4UiState> {
  late final String projectId;

  Stage4UiState build(String projectId);
}

/// See also [Stage4Ui].
@ProviderFor(Stage4Ui)
const stage4UiProvider = Stage4UiFamily();

/// See also [Stage4Ui].
class Stage4UiFamily extends Family<Stage4UiState> {
  /// See also [Stage4Ui].
  const Stage4UiFamily();

  /// See also [Stage4Ui].
  Stage4UiProvider call(String projectId) {
    return Stage4UiProvider(projectId);
  }

  @override
  Stage4UiProvider getProviderOverride(covariant Stage4UiProvider provider) {
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
  String? get name => r'stage4UiProvider';
}

/// See also [Stage4Ui].
class Stage4UiProvider
    extends AutoDisposeNotifierProviderImpl<Stage4Ui, Stage4UiState> {
  /// See also [Stage4Ui].
  Stage4UiProvider(String projectId)
    : this._internal(
        () => Stage4Ui()..projectId = projectId,
        from: stage4UiProvider,
        name: r'stage4UiProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$stage4UiHash,
        dependencies: Stage4UiFamily._dependencies,
        allTransitiveDependencies: Stage4UiFamily._allTransitiveDependencies,
        projectId: projectId,
      );

  Stage4UiProvider._internal(
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
  Stage4UiState runNotifierBuild(covariant Stage4Ui notifier) {
    return notifier.build(projectId);
  }

  @override
  Override overrideWith(Stage4Ui Function() create) {
    return ProviderOverride(
      origin: this,
      override: Stage4UiProvider._internal(
        () => create()..projectId = projectId,
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
  AutoDisposeNotifierProviderElement<Stage4Ui, Stage4UiState> createElement() {
    return _Stage4UiProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is Stage4UiProvider && other.projectId == projectId;
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
mixin Stage4UiRef on AutoDisposeNotifierProviderRef<Stage4UiState> {
  /// The parameter `projectId` of this provider.
  String get projectId;
}

class _Stage4UiProviderElement
    extends AutoDisposeNotifierProviderElement<Stage4Ui, Stage4UiState>
    with Stage4UiRef {
  _Stage4UiProviderElement(super.provider);

  @override
  String get projectId => (origin as Stage4UiProvider).projectId;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
