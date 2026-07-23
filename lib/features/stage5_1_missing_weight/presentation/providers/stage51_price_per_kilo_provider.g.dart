// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stage51_price_per_kilo_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Stage5PricePerKilo)
final stage5PricePerKiloProvider = Stage5PricePerKiloFamily._();

final class Stage5PricePerKiloProvider
    extends $NotifierProvider<Stage5PricePerKilo, double?> {
  Stage5PricePerKiloProvider._({
    required Stage5PricePerKiloFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'stage5PricePerKiloProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$stage5PricePerKiloHash();

  @override
  String toString() {
    return r'stage5PricePerKiloProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  Stage5PricePerKilo create() => Stage5PricePerKilo();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(double? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<double?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is Stage5PricePerKiloProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$stage5PricePerKiloHash() =>
    r'4926630fcae4f29219035c7afd552084ebf526aa';

final class Stage5PricePerKiloFamily extends $Family
    with
        $ClassFamilyOverride<
          Stage5PricePerKilo,
          double?,
          double?,
          double?,
          String
        > {
  Stage5PricePerKiloFamily._()
    : super(
        retry: null,
        name: r'stage5PricePerKiloProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  Stage5PricePerKiloProvider call(String projectId) =>
      Stage5PricePerKiloProvider._(argument: projectId, from: this);

  @override
  String toString() => r'stage5PricePerKiloProvider';
}

abstract class _$Stage5PricePerKilo extends $Notifier<double?> {
  late final _$args = ref.$arg as String;
  String get projectId => _$args;

  double? build(String projectId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<double?, double?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<double?, double?>,
              double?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
