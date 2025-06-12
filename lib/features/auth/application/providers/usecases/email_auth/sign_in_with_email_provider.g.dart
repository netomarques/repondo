// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_in_with_email_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$signInWithEmailHash() => r'3f8939a71a176f00c0b02b944e62d192e40d6b9c';

/// Provider do usecase para login com email e senha.
///
/// Copied from [signInWithEmail].
@ProviderFor(signInWithEmail)
final signInWithEmailProvider =
    AutoDisposeProvider<SignInWithEmailAndPasswordUseCase>.internal(
  signInWithEmail,
  name: r'signInWithEmailProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$signInWithEmailHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SignInWithEmailRef
    = AutoDisposeProviderRef<SignInWithEmailAndPasswordUseCase>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
