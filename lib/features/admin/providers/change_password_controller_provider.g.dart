// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'change_password_controller_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$changePasswordUseCaseHash() =>
    r'ad239a0aa14132ce4190ce253741c2dca217528c';

/// See also [changePasswordUseCase].
@ProviderFor(changePasswordUseCase)
final changePasswordUseCaseProvider =
    AutoDisposeProvider<AdminChangeUserPasswordUseCase>.internal(
      changePasswordUseCase,
      name: r'changePasswordUseCaseProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$changePasswordUseCaseHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ChangePasswordUseCaseRef =
    AutoDisposeProviderRef<AdminChangeUserPasswordUseCase>;
String _$changePasswordControllerHash() =>
    r'34bf25adf7a5d6ade31d0d19cd88435812df7da5';

/// See also [ChangePasswordController].
@ProviderFor(ChangePasswordController)
final changePasswordControllerProvider =
    AutoDisposeNotifierProvider<
      ChangePasswordController,
      AsyncValue<void>
    >.internal(
      ChangePasswordController.new,
      name: r'changePasswordControllerProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$changePasswordControllerHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ChangePasswordController = AutoDisposeNotifier<AsyncValue<void>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
