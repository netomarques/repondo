import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:repondo/core/auth_service.dart';

import '../mocks/mocks.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('AuthService', () {
    late AuthService authService;
    late MockGoogleSignIn mockGoogleSignIn;
    late MockFirebaseAuth mockFirebaseAuth;
    late MockUser mockUser;
    late MockUserCredential mockUserCredential;
    late MockGoogleSignInAccount mockGoogleSignInAccount;
    late MockGoogleSignInAuthentication mockGoogleSignInAuthentication;

    setUp(() {
      mockFirebaseAuth = MockFirebaseAuth();
      mockUser = MockUser();
      mockUserCredential = MockUserCredential();
      mockGoogleSignIn = MockGoogleSignIn();
      mockGoogleSignInAccount = MockGoogleSignInAccount();
      mockGoogleSignInAuthentication = MockGoogleSignInAuthentication();
      authService = AuthService(
        firebaseAuth: mockFirebaseAuth,
        googleSignIn: mockGoogleSignIn,
      );

      // Configurando o mockUser para retornar um email válido
      when(mockUser.email).thenReturn('email@example.com');
      when(mockUser.uid).thenReturn('userId');

      when(mockGoogleSignIn.signOut()).thenAnswer((_) async => null);
      when(mockGoogleSignIn.currentUser).thenReturn(null);

      when(mockGoogleSignIn.signIn())
          .thenAnswer((_) async => mockGoogleSignInAccount);
      when(mockFirebaseAuth.signInWithCredential(any))
          .thenAnswer((_) async => mockUserCredential);

      when(mockGoogleSignInAccount.authentication)
          .thenAnswer((_) async => mockGoogleSignInAuthentication);
      when(mockGoogleSignInAuthentication.accessToken)
          .thenReturn('fakeAccessToken');
      when(mockGoogleSignInAuthentication.idToken).thenReturn('fakeIdToken');
    });

    test('Deve registrar um novo usuário com email e senha', () async {
      when(mockUserCredential.user).thenReturn(mockUser);
      when(mockFirebaseAuth.createUserWithEmailAndPassword(
        email: 'email@example.com',
        password: 'password',
        // email: anyNamed('email'),
        // password: anyNamed('password'),
      )).thenAnswer((_) async => mockUserCredential);

      final result = await authService.registerWithEmailAndPassword(
        'email@example.com',
        'password',
      );

      expect(result, isNotNull);
      expect(result?.email, 'email@example.com');
    });

    test('Deve fazer login com email e senha', () async {
      when(mockUserCredential.user).thenReturn(mockUser);
      when(mockFirebaseAuth.signInWithEmailAndPassword(
        email: 'email@example.com',
        password: 'password',
      )).thenAnswer((_) async => mockUserCredential);

      final result = await authService.signInWithEmailAndPassword(
        'email@example.com',
        'password',
      );

      expect(result, isNotNull);
      expect(result?.email, 'email@example.com');
    });

    test('Deve retornar o usuário autenticado no getter currentUser', () {
      when(mockFirebaseAuth.currentUser).thenReturn(mockUser);

      final result = authService.currentUser;

      expect(result, isNotNull);
      expect(result?.email, 'email@example.com');
    });

    test(
        'Deve retornar null no getter currentUser quando não há usuário autenticado',
        () {
      when(mockFirebaseAuth.currentUser).thenReturn(null);

      final result = authService.currentUser;

      expect(result, isNull);
    });

    test(
        'Deve falhar ao registrar um novo usuário com email e senha e lançar AuthException genérica para erro desconhecido',
        () async {
      when(mockFirebaseAuth.createUserWithEmailAndPassword(
        email: 'email@example.com',
        password: 'password',
      )).thenThrow(
          Exception('Erro ao registrar um novo usuário com email e senha'));

      expect(
          () => authService.registerWithEmailAndPassword(
              'email@example.com', 'password'),
          throwsA(isA<Exception>()));
    });

    test(
        'Deve falhar no login com email e senha e lançar AuthException genérica para erro desconhecido',
        () async {
      when(mockFirebaseAuth.signInWithEmailAndPassword(
        email: 'email@example.com',
        password: 'password',
      )).thenThrow(Exception('Erro no login com email e senha'));

      expect(
        () => authService.signInWithEmailAndPassword(
          'email@example.com',
          'password',
        ),
        throwsA(isA<AuthException>()),
      );
    });

    test('Deve fazer logout', () async {
      await authService.signOut();
      expect(mockGoogleSignIn.currentUser, isNull);
    });

    test('Deve fazer login com Google', () async {
      when(mockUserCredential.user).thenReturn(mockUser);
      final result = await authService.signInWithGoogle();

      expect(result, isNotNull);
      expect(result?.email, 'email@example.com');
    });

    test('Deve retornar null quando o login com Google for cancelado',
        () async {
      when(mockGoogleSignIn.signIn()).thenAnswer((_) async => null);

      final result = await authService.signInWithGoogle();

      expect(result, isNull);
    });

    test('Deve falhar no login com Google', () async {
      when(mockGoogleSignIn.signIn())
          .thenThrow(Exception('Erro ao fazer login com o Google'));

      expect(
        () => authService.signInWithGoogle(),
        throwsA(isA<AuthException>()),
      );
    });

    test('Deve fazer logout', () async {
      await authService.signOut();
      expect(mockGoogleSignIn.currentUser, isNull);
    });

    test('Deve falhar ao fazer logout', () async {
      when(mockGoogleSignIn.signOut())
          .thenThrow(Exception('Erro ao fazer logout'));

      expect(
        () => authService.signOut(),
        throwsA(isA<Exception>()),
      );
    });

    test('Deve lançar AuthException para email já em uso', () async {
      when(mockFirebaseAuth.createUserWithEmailAndPassword(
        email: 'email@example.com',
        password: 'password',
      )).thenThrow(FirebaseAuthException(code: 'email-already-in-use'));

      expect(
        () => authService.registerWithEmailAndPassword(
            'email@example.com', 'password'),
        throwsA(
          predicate<AuthException>(
              (e) => e.message == 'O e-mail já está em uso.'),
        ),
      );
    });

    test('Deve lançar AuthException para senha incorreta', () async {
      when(mockFirebaseAuth.signInWithEmailAndPassword(
        email: 'email@example.com',
        password: 'wrong-password',
      )).thenThrow(FirebaseAuthException(code: 'wrong-password'));

      expect(
        () => authService.signInWithEmailAndPassword(
            'email@example.com', 'wrong-password'),
        throwsA(
          predicate<AuthException>((e) => e.message == 'Senha incorreta.'),
        ),
      );
    });

    test('Deve lançar AuthException para usuário não encontrado', () async {
      when(mockFirebaseAuth.signInWithEmailAndPassword(
        email: 'email@example.com',
        password: 'password',
      )).thenThrow(FirebaseAuthException(code: 'user-not-found'));

      expect(
        () => authService.signInWithEmailAndPassword(
            'email@example.com', 'password'),
        throwsA(
          predicate<AuthException>(
              (e) => e.message == 'Usuário não encontrado.'),
        ),
      );
    });

    test('Deve lançar AuthException para email inválido', () async {
      when(mockFirebaseAuth.createUserWithEmailAndPassword(
        email: 'invalid-email',
        password: 'password',
      )).thenThrow(FirebaseAuthException(code: 'invalid-email'));

      expect(
        () => authService.registerWithEmailAndPassword(
            'invalid-email', 'password'),
        throwsA(
          predicate<AuthException>((e) => e.message == 'E-mail inválido.'),
        ),
      );
    });

    test('Deve lançar AuthException para conta desativada', () async {
      when(mockFirebaseAuth.signInWithEmailAndPassword(
        email: 'email@example.com',
        password: 'password',
      )).thenThrow(FirebaseAuthException(code: 'user-disabled'));

      expect(
        () => authService.signInWithEmailAndPassword(
            'email@example.com', 'password'),
        throwsA(
          predicate<AuthException>(
              (e) => e.message == 'Esta conta foi desativada.'),
        ),
      );
    });

    test('Deve lançar AuthException para muitas tentativas de login', () async {
      when(mockFirebaseAuth.signInWithEmailAndPassword(
        email: 'email@example.com',
        password: 'password',
      )).thenThrow(FirebaseAuthException(code: 'too-many-requests'));

      expect(
        () => authService.signInWithEmailAndPassword(
            'email@example.com', 'password'),
        throwsA(
          predicate<AuthException>((e) =>
              e.message ==
              'Muitas tentativas de login. Tente novamente mais tarde.'),
        ),
      );
    });
  });
}
