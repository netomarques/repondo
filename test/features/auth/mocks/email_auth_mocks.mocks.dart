// Mocks generated by Mockito 5.4.5 from annotations
// in repondo/test/features/auth/mocks/email_auth_mocks.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i7;
import 'package:repondo/core/result/result.dart' as _i4;
import 'package:repondo/features/auth/application/facades/email_auth_facade.dart'
    as _i2;
import 'package:repondo/features/auth/domain/entities/user_auth.dart' as _i5;
import 'package:repondo/features/auth/domain/exceptions/auth_exception.dart'
    as _i6;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: must_be_immutable
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

/// A class which mocks [EmailAuthFacade].
///
/// See the documentation for Mockito's code generation for more information.
class MockEmailAuthFacade extends _i1.Mock implements _i2.EmailAuthFacade {
  MockEmailAuthFacade() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Stream<_i4.Result<_i5.UserAuth?, _i6.AuthException>>
  get observeUserAuth =>
      (super.noSuchMethod(
            Invocation.getter(#observeUserAuth),
            returnValue:
                _i3.Stream<
                  _i4.Result<_i5.UserAuth?, _i6.AuthException>
                >.empty(),
          )
          as _i3.Stream<_i4.Result<_i5.UserAuth?, _i6.AuthException>>);

  @override
  _i3.Future<_i4.Result<_i5.UserAuth, _i6.AuthException>> signInWithEmail(
    String? email,
    String? password,
  ) =>
      (super.noSuchMethod(
            Invocation.method(#signInWithEmail, [email, password]),
            returnValue:
                _i3.Future<_i4.Result<_i5.UserAuth, _i6.AuthException>>.value(
                  _i7.dummyValue<_i4.Result<_i5.UserAuth, _i6.AuthException>>(
                    this,
                    Invocation.method(#signInWithEmail, [email, password]),
                  ),
                ),
          )
          as _i3.Future<_i4.Result<_i5.UserAuth, _i6.AuthException>>);

  @override
  _i3.Future<_i4.Result<_i5.UserAuth, _i6.AuthException>> signUpWithEmail(
    String? email,
    String? password,
  ) =>
      (super.noSuchMethod(
            Invocation.method(#signUpWithEmail, [email, password]),
            returnValue:
                _i3.Future<_i4.Result<_i5.UserAuth, _i6.AuthException>>.value(
                  _i7.dummyValue<_i4.Result<_i5.UserAuth, _i6.AuthException>>(
                    this,
                    Invocation.method(#signUpWithEmail, [email, password]),
                  ),
                ),
          )
          as _i3.Future<_i4.Result<_i5.UserAuth, _i6.AuthException>>);

  @override
  _i3.Future<_i4.Result<void, _i6.AuthException>> signOut() =>
      (super.noSuchMethod(
            Invocation.method(#signOut, []),
            returnValue: _i3.Future<_i4.Result<void, _i6.AuthException>>.value(
              _i7.dummyValue<_i4.Result<void, _i6.AuthException>>(
                this,
                Invocation.method(#signOut, []),
              ),
            ),
          )
          as _i3.Future<_i4.Result<void, _i6.AuthException>>);

  @override
  _i3.Future<_i4.Result<_i5.UserAuth?, _i6.AuthException>> getCurrentUser() =>
      (super.noSuchMethod(
            Invocation.method(#getCurrentUser, []),
            returnValue:
                _i3.Future<_i4.Result<_i5.UserAuth?, _i6.AuthException>>.value(
                  _i7.dummyValue<_i4.Result<_i5.UserAuth?, _i6.AuthException>>(
                    this,
                    Invocation.method(#getCurrentUser, []),
                  ),
                ),
          )
          as _i3.Future<_i4.Result<_i5.UserAuth?, _i6.AuthException>>);
}
