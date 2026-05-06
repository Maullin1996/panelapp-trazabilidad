// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Notifier de autenticación con Riverpod (keepAlive).

@ProviderFor(Auth)
final authProvider = AuthProvider._();

/// Notifier de autenticación con Riverpod (keepAlive).
final class AuthProvider extends $NotifierProvider<Auth, AuthParams> {
  /// Notifier de autenticación con Riverpod (keepAlive).
  AuthProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authHash();

  @$internal
  @override
  Auth create() => Auth();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthParams value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthParams>(value),
    );
  }
}

String _$authHash() => r'ffc69470a68e23417d6e5d44e097ac1bc1104dd8';

/// Notifier de autenticación con Riverpod (keepAlive).

abstract class _$Auth extends $Notifier<AuthParams> {
  AuthParams build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AuthParams, AuthParams>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AuthParams, AuthParams>,
              AuthParams,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
