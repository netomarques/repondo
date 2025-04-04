import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:repondo/core/firestore_service.dart';

import 'firestore_service_test.mocks.dart';

late FirestoreService firestoreService;
late MockFirebaseFirestore mockFirestore;
late MockTransaction mockTransaction;
late MockCollectionReference<Map<String, dynamic>> mockDespensasCollection;
late MockCollectionReference<Map<String, dynamic>> mockUsersCollection;
late MockCollectionReference<Map<String, dynamic>> mockUsuariosCollection;
late MockCollectionReference<Map<String, dynamic>> mockUserDespensasCollection;
late MockDocumentReference<Map<String, dynamic>> mockDespensaDoc;
late MockDocumentReference<Map<String, dynamic>> mockUserDoc;
late MockDocumentReference<Map<String, dynamic>> mockUsuarioDoc;
late MockDocumentReference<Map<String, dynamic>> mockUserDespensaDoc;

const testUserId = 'testUserId';
const testDespensaId = 'testDespensaId';

@GenerateMocks([
  FirebaseFirestore,
  Transaction,
  CollectionReference<Map<String, dynamic>>,
  DocumentReference<Map<String, dynamic>>,
])
void main() {
  mockFirestore = MockFirebaseFirestore();
  mockTransaction = MockTransaction();
  mockDespensasCollection = MockCollectionReference();
  mockUsersCollection = MockCollectionReference();
  mockUsuariosCollection = MockCollectionReference();
  mockUserDespensasCollection = MockCollectionReference();
  mockDespensaDoc = MockDocumentReference();
  mockUserDoc = MockDocumentReference();
  mockUsuarioDoc = MockDocumentReference();
  mockUserDespensaDoc = MockDocumentReference();
  firestoreService = FirestoreService(firebaseFirestore: mockFirestore);

  group('FirestoreService', () {
    setUp(() {
      reset(mockFirestore);
      reset(mockTransaction);
      reset(mockDespensasCollection);
      reset(mockUsersCollection);
      reset(mockUsuariosCollection);
      reset(mockUserDespensasCollection);
      reset(mockDespensaDoc);
      reset(mockUserDoc);
      reset(mockUsuarioDoc);
      reset(mockUserDespensaDoc);

      // Configuração base dos mocks
      when(mockFirestore.collection(FirestoreConstants.despensasCollection))
          .thenReturn(mockDespensasCollection);
      when(mockFirestore.collection(FirestoreConstants.usersCollection))
          .thenReturn(mockUsersCollection);

      when(mockDespensasCollection.doc(testDespensaId))
          .thenReturn(mockDespensaDoc);
      when(mockUsersCollection.doc(testUserId)).thenReturn(mockUserDoc);

      when(mockDespensaDoc.collection(FirestoreConstants.usuariosSubcollection))
          .thenReturn(mockUsuariosCollection);
      when(mockUserDoc.collection(FirestoreConstants.despensasSubcollection))
          .thenReturn(mockUserDespensasCollection);

      when(mockUsuariosCollection.doc(testUserId)).thenReturn(mockUsuarioDoc);
      when(mockUserDespensasCollection.doc(testDespensaId))
          .thenReturn(mockUserDespensaDoc);

      when(mockFirestore.runTransaction(any)).thenAnswer((invocation) async {
        final transactionCallback = invocation.positionalArguments.first
            as Future<void> Function(Transaction);
        await transactionCallback(mockTransaction);
      });
    });

    group('addUserToDespensa', () {
      setUp(() {
        // Configura os mocks para as operações de set
        when(mockTransaction.set(mockUsuarioDoc, {
          FirestoreConstants.roleField: FirestoreConstants.memberRole
        })).thenReturn(mockTransaction);
        when(mockTransaction.set(mockUserDespensaDoc, {}))
            .thenReturn(mockTransaction);
      });

      group('runTransaction', () {
        test('Deve chamar runTransaction uma vez por operação', () async {
          const testUserId2 = 'testUserId2';
          const testDespensaId2 = 'testDespensaId2';

          when(mockDespensasCollection.doc(testDespensaId2))
              .thenReturn(mockDespensaDoc);
          when(mockUsersCollection.doc(testUserId2)).thenReturn(mockUserDoc);

          when(mockUsuariosCollection.doc(testUserId2))
              .thenReturn(mockUsuarioDoc);
          when(mockUserDespensasCollection.doc(testDespensaId2))
              .thenReturn(mockUserDespensaDoc);

          await firestoreService.addUserToDespensa(testUserId, testDespensaId);
          await firestoreService.addUserToDespensa(
              testUserId2, testDespensaId2);
          verify(mockFirestore.runTransaction(any)).called(2);
        });
      });

      group('Validação de parâmetros', () {
        test('Deve lançar exceção para userId vazio', () async {
          expect(
            () => firestoreService.addUserToDespensa('', testDespensaId),
            throwsA(isA<ArgumentError>()),
          );

          verifyNever(mockFirestore.runTransaction(any));
          verifyNever(mockTransaction.set(mockUsuarioDoc,
              {FirestoreConstants.roleField: FirestoreConstants.memberRole}));
          verifyNever(mockTransaction.set(mockUserDespensaDoc, {}));
        });

        test('Deve lançar exceção para userId null', () async {
          const userIdIsNull = null;

          expect(
            () => firestoreService.addUserToDespensa(
                userIdIsNull, testDespensaId),
            throwsA(isA<TypeError>()),
          );

          verifyNever(mockFirestore.runTransaction(any));
          verifyNever(mockTransaction.set(mockUsuarioDoc,
              {FirestoreConstants.roleField: FirestoreConstants.memberRole}));
          verifyNever(mockTransaction.set(mockUserDespensaDoc, {}));
        });

        test('Deve lançar exceção para despensaId vazio', () async {
          expect(
            () => firestoreService.addUserToDespensa(testUserId, ''),
            throwsA(isA<ArgumentError>()),
          );

          verifyNever(mockFirestore.runTransaction(any));
          verifyNever(mockTransaction.set(mockUsuarioDoc,
              {FirestoreConstants.roleField: FirestoreConstants.memberRole}));
          verifyNever(mockTransaction.set(mockUserDespensaDoc, {}));
        });

        test('Deve lançar exceção para despensaId null', () async {
          const despensaIdIsNull = null;

          expect(
            () => firestoreService.addUserToDespensa(
                testUserId, despensaIdIsNull),
            throwsA(isA<TypeError>()),
          );

          verifyNever(mockFirestore.runTransaction(any));
          verifyNever(mockTransaction.set(mockUsuarioDoc,
              {FirestoreConstants.roleField: FirestoreConstants.memberRole}));
          verifyNever(mockTransaction.set(mockUserDespensaDoc, {}));
        });
      });

      group('casos de sucesso', () {
        test('Deve adicionar um usuário à despensa', () async {
          await firestoreService.addUserToDespensa(testUserId, testDespensaId);

          verify(mockFirestore.runTransaction(any)).called(1);

          // Verifica se os sets foram chamados com os parâmetros corretos
          verify(mockTransaction.set(mockUsuarioDoc, {
            FirestoreConstants.roleField: FirestoreConstants.memberRole
          })).called(1);
          verify(mockTransaction.set(mockUserDespensaDoc, {})).called(1);
        });
      });

      group('casos de erro', () {
        test(
            'Deve lançar FirestoreException em caso de erro ao adicionar um usuário à despensa, erro deve ocorrer na transaction',
            () async {
          when(mockFirestore.runTransaction(any))
              .thenThrow(FirebaseException(plugin: 'firestore'));

          expect(
            () =>
                firestoreService.addUserToDespensa(testUserId, testDespensaId),
            throwsA(isA<FirestoreException>()),
          );

          verify(mockFirestore.runTransaction(any)).called(1);

          verifyNever(mockTransaction.set(mockUsuarioDoc,
              {FirestoreConstants.roleField: FirestoreConstants.memberRole}));
          verifyNever(mockTransaction.set(mockUserDespensaDoc, {}));
        });

        test(
            'Deve lançar FirestoreException em caso de erro ao adicionar usuário na despensa, erro deve ocorrer quando adicionar usuário na collection despensas',
            () async {
          when(mockTransaction.set(mockUsuarioDoc, {
            FirestoreConstants.roleField: FirestoreConstants.memberRole
          })).thenThrow(FirebaseException(plugin: 'firestore'));

          expect(
            () =>
                firestoreService.addUserToDespensa(testUserId, testDespensaId),
            throwsA(isA<FirestoreException>()),
          );

          verify(mockFirestore.runTransaction(any)).called(1);

          verify(mockTransaction.set(mockUsuarioDoc, {
            FirestoreConstants.roleField: FirestoreConstants.memberRole
          })).called(1);
          verifyNever(mockTransaction.set(mockUserDespensaDoc, {}));
        });

        test(
            'Deve lançar FirestoreException em caso de erro ao adicionar usuário na despensa, erro deve ocorrer quando adicionar despensa na collection users',
            () async {
          when(mockTransaction.set(mockUserDespensaDoc, {}))
              .thenThrow(FirebaseException(plugin: 'firestore'));

          expect(
            () =>
                firestoreService.addUserToDespensa(testUserId, testDespensaId),
            throwsA(isA<FirestoreException>()),
          );

          verify(mockFirestore.runTransaction(any)).called(1);
          verify(mockTransaction.set(mockUsuarioDoc, {
            FirestoreConstants.roleField: FirestoreConstants.memberRole
          })).called(1);
          verify(mockTransaction.set(mockUserDespensaDoc, {})).called(1);
        });

        test('Deve lançar FirestoreException para erros desconhecidos',
            () async {
          when(mockFirestore.runTransaction(any))
              .thenThrow(Exception('Erro desconhecido'));

          expect(
            () =>
                firestoreService.addUserToDespensa(testUserId, testDespensaId),
            throwsA(isA<FirestoreException>()),
          );
        });
      });
    });

    group('removeUserFromDespensa', () {
      setUp(() {
        // Configura os mocks para as operações de delete
        when(mockTransaction.delete(mockUsuarioDoc))
            .thenReturn(mockTransaction);
        when(mockTransaction.delete(mockUserDespensaDoc))
            .thenReturn(mockTransaction);
      });

      group('runTransaction', () {
        test('Deve chamar runTransaction uma vez por operação', () async {
          const testUserId2 = 'testUserId2';
          const testDespensaId2 = 'testDespensaId2';

          when(mockDespensasCollection.doc(testDespensaId2))
              .thenReturn(mockDespensaDoc);
          when(mockUsersCollection.doc(testUserId2)).thenReturn(mockUserDoc);

          when(mockUsuariosCollection.doc(testUserId2))
              .thenReturn(mockUsuarioDoc);
          when(mockUserDespensasCollection.doc(testDespensaId2))
              .thenReturn(mockUserDespensaDoc);

          await firestoreService.removeUserFromDespensa(
              testUserId, testDespensaId);
          await firestoreService.removeUserFromDespensa(
              testUserId2, testDespensaId2);
          verify(mockFirestore.runTransaction(any)).called(2);
        });
      });

      group('Validação de parâmetros', () {
        test('Deve lançar exceção para userId vazio', () async {
          expect(
            () => firestoreService.removeUserFromDespensa('', testDespensaId),
            throwsA(isA<ArgumentError>()),
          );

          verifyNever(mockFirestore.runTransaction(any));
          verifyNever(mockTransaction.delete(mockUsuarioDoc));
          verifyNever(mockTransaction.delete(mockUserDespensaDoc));
        });

        test('Deve lançar exceção para userId null', () async {
          const userIdIsNull = null;

          expect(
            () => firestoreService.removeUserFromDespensa(
                userIdIsNull, testDespensaId),
            throwsA(isA<TypeError>()),
          );

          verifyNever(mockFirestore.runTransaction(any));
          verifyNever(mockTransaction.delete(mockUsuarioDoc));
          verifyNever(mockTransaction.delete(mockUserDespensaDoc));
        });

        test('Deve lançar exceção para despensaId vazio', () async {
          expect(
            () => firestoreService.removeUserFromDespensa(testUserId, ''),
            throwsA(isA<ArgumentError>()),
          );

          verifyNever(mockFirestore.runTransaction(any));
          verifyNever(mockTransaction.delete(mockUsuarioDoc));
          verifyNever(mockTransaction.delete(mockUserDespensaDoc));
        });

        test('Deve lançar exceção para despensaId null', () async {
          const despensaIdIsNull = null;

          expect(
            () => firestoreService.removeUserFromDespensa(
                testUserId, despensaIdIsNull),
            throwsA(isA<TypeError>()),
          );

          verifyNever(mockFirestore.runTransaction(any));
          verifyNever(mockTransaction.delete(mockUsuarioDoc));
          verifyNever(mockTransaction.delete(mockUserDespensaDoc));
        });
      });

      group('casos de sucesso', () {
        test('Deve remover um usuário de uma despensa', () async {
          await firestoreService.removeUserFromDespensa(
              testUserId, testDespensaId);

          // Verifica se os deletes foram chamados
          verify(mockFirestore.runTransaction(any)).called(1);
          verify(mockTransaction.delete(mockUsuarioDoc)).called(1);
          verify(mockTransaction.delete(mockUserDespensaDoc)).called(1);
        });
      });

      group('casos de erro', () {
        test(
            'Deve lançar FirestoreException em caso de erro ao remover, erro deve ocorrer na transaction',
            () async {
          // Configura um mock para lançar exceção
          when(mockFirestore.runTransaction(any))
              .thenThrow(FirebaseException(plugin: 'firestore'));

          expect(
            () => firestoreService.removeUserFromDespensa(
                testUserId, testDespensaId),
            throwsA(isA<FirestoreException>()),
          );

          verify(mockFirestore.runTransaction(any)).called(1);
          verifyNever(mockTransaction.delete(mockUsuarioDoc));
          verifyNever(mockTransaction.delete(mockUserDespensaDoc));
        });

        test(
            'Deve lançar FirestoreException em caso de erro ao remover, erro deve ocorrer quando remover usuário da collection despensas',
            () async {
          // Configura um mock para lançar exceção
          when(mockTransaction.delete(mockUsuarioDoc))
              .thenThrow(FirebaseException(plugin: 'firestore'));

          expect(
            () => firestoreService.removeUserFromDespensa(
                testUserId, testDespensaId),
            throwsA(isA<FirestoreException>()),
          );

          verify(mockFirestore.runTransaction(any)).called(1);
          verify(mockTransaction.delete(mockUsuarioDoc)).called(1);
          verifyNever(mockTransaction.delete(mockUserDespensaDoc));
        });

        test(
            'Deve lançar FirestoreException em caso de erro ao remover, erro deve ocorrer quando remover despensa da collection users',
            () async {
          // Configura um mock para lançar exceção
          when(mockTransaction.delete(mockUserDespensaDoc))
              .thenThrow(FirebaseException(plugin: 'firestore'));

          expect(
            () => firestoreService.removeUserFromDespensa(
                testUserId, testDespensaId),
            throwsA(isA<FirestoreException>()),
          );

          verify(mockFirestore.runTransaction(any)).called(1);
          verify(mockTransaction.delete(mockUsuarioDoc)).called(1);
          verify(mockTransaction.delete(mockUserDespensaDoc)).called(1);
        });

        test('Deve lançar FirestoreException para erros desconhecidos',
            () async {
          when(mockFirestore.runTransaction(any))
              .thenThrow(Exception('Erro desconhecido'));

          expect(
            () => firestoreService.removeUserFromDespensa(
                testUserId, testDespensaId),
            throwsA(isA<FirestoreException>()),
          );
        });
      });
    });

    group('FirestoreException', () {
      test('Deve conter mensagem de erro', () {
        const errorMessage = 'Test error';
        final exception = FirestoreException(errorMessage);

        expect(exception.message, errorMessage);
        expect(exception.toString(), contains(errorMessage));
      });
    });
  });
}
