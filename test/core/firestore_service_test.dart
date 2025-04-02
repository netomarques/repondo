import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:repondo/core/firestore_service.dart';

import 'firestore_service_test.mocks.dart';

@GenerateMocks([
  FirebaseFirestore,
  Transaction,
  CollectionReference<Map<String, dynamic>>,
  DocumentReference<Map<String, dynamic>>,
])
void main() {
  group('FirestoreService', () {
    late FirestoreService firestoreService;
    late MockFirebaseFirestore mockFirestore;
    late MockTransaction mockTransaction;
    late MockCollectionReference<Map<String, dynamic>> mockDespensasCollection;
    late MockCollectionReference<Map<String, dynamic>> mockUsersCollection;
    late MockCollectionReference<Map<String, dynamic>> mockUsuariosCollection;
    late MockCollectionReference<Map<String, dynamic>>
        mockUserDespensasCollection;
    late MockDocumentReference<Map<String, dynamic>> mockDespensaDoc;
    late MockDocumentReference<Map<String, dynamic>> mockUserDoc;
    late MockDocumentReference<Map<String, dynamic>> mockUsuarioDoc;
    late MockDocumentReference<Map<String, dynamic>> mockUserDespensaDoc;

    const testUserId = 'testUserId';
    const testDespensaId = 'testDespensaId';

    setUp(() {
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

      firestoreService = FirestoreService(firebaseFirestore: mockFirestore);
    });

    test('Deve adicionar um usuário à despensa', () async {
      when(mockFirestore.runTransaction(any)).thenAnswer((invocation) async {
        final transactionCallback = invocation.positionalArguments.first
            as Future<void> Function(Transaction);
        await transactionCallback(mockTransaction);
      });

      // Configura os mocks para as operações de set
      when(mockTransaction.set(mockUsuarioDoc, {
        FirestoreConstants.roleField: FirestoreConstants.memberRole
      })).thenReturn(mockTransaction);
      when(mockTransaction.set(mockUserDespensaDoc, {}))
          .thenReturn(mockTransaction);

      await firestoreService.addUserToDespensa(testUserId, testDespensaId);

      verify(mockFirestore.runTransaction(any)).called(1);

      // Verifica se os sets foram chamados com os parâmetros corretos
      verify(mockTransaction.set(mockUsuarioDoc, {
        FirestoreConstants.roleField: FirestoreConstants.memberRole
      })).called(1);
      verify(mockTransaction.set(mockUserDespensaDoc, {})).called(1);
    });

    test('Deve remover um usuário de uma despensa', () async {
      // Configura os mocks para as operações de delete
      when(mockFirestore.runTransaction(any)).thenAnswer((invocation) async {
        final transactionCallback = invocation.positionalArguments.first
            as Future<void> Function(Transaction);
        await transactionCallback(mockTransaction);
      });

      when(mockTransaction.delete(mockUsuarioDoc)).thenReturn(mockTransaction);
      when(mockTransaction.delete(mockUserDespensaDoc))
          .thenReturn(mockTransaction);

      await firestoreService.removeUserFromDespensa(testUserId, testDespensaId);

      // Verifica se os deletes foram chamados
      verify(mockFirestore.runTransaction(any)).called(1);
      verify(mockTransaction.delete(mockUsuarioDoc)).called(1);
      verify(mockTransaction.delete(mockUserDespensaDoc)).called(1);
    });

    test(
        'Deve lançar FirestoreException em caso de erro ao adicionar um usuário à despensa, erro deve ocorrer na transaction',
        () async {
      when(mockFirestore.runTransaction(any))
          .thenThrow(FirebaseException(plugin: 'firestore'));

      when(mockTransaction.set(mockUsuarioDoc, {
        FirestoreConstants.roleField: FirestoreConstants.memberRole
      })).thenReturn(mockTransaction);
      when(mockTransaction.set(mockUserDespensaDoc, {}))
          .thenReturn(mockTransaction);

      expect(
        () => firestoreService.addUserToDespensa(testUserId, testDespensaId),
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
      when(mockFirestore.runTransaction(any)).thenAnswer((invocation) async {
        final transactionCallback = invocation.positionalArguments.first
            as Future<void> Function(Transaction);
        await transactionCallback(mockTransaction);
      });

      when(mockTransaction.set(mockUsuarioDoc, {
        FirestoreConstants.roleField: FirestoreConstants.memberRole
      })).thenThrow(FirebaseException(plugin: 'firestore'));
      when(mockTransaction.set(mockUserDespensaDoc, {}))
          .thenReturn(mockTransaction);

      expect(
        () => firestoreService.addUserToDespensa(testUserId, testDespensaId),
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
      // Configura um mock para lançar exceção
      when(mockFirestore.runTransaction(any)).thenAnswer((invocation) async {
        final transactionCallback = invocation.positionalArguments.first
            as Future<void> Function(Transaction);
        await transactionCallback(mockTransaction);
      });

      when(mockTransaction.set(mockUsuarioDoc, {
        FirestoreConstants.roleField: FirestoreConstants.memberRole
      })).thenReturn(mockTransaction);
      when(mockTransaction.set(mockUserDespensaDoc, {}))
          .thenThrow(FirebaseException(plugin: 'firestore'));

      expect(
        () => firestoreService.addUserToDespensa(testUserId, testDespensaId),
        throwsA(isA<FirestoreException>()),
      );

      verify(mockFirestore.runTransaction(any)).called(1);
      verify(mockTransaction.set(mockUsuarioDoc, {
        FirestoreConstants.roleField: FirestoreConstants.memberRole
      })).called(1);
      verify(mockTransaction.set(mockUserDespensaDoc, {})).called(1);
    });

    test(
        'Deve lançar FirestoreException em caso de erro ao remover, erro deve ocorrer na transaction',
        () async {
      // Configura um mock para lançar exceção
      when(mockFirestore.runTransaction(any))
          .thenThrow(FirebaseException(plugin: 'firestore'));

      when(mockTransaction.delete(mockUsuarioDoc)).thenReturn(mockTransaction);
      when(mockTransaction.delete(mockUserDespensaDoc))
          .thenReturn(mockTransaction);

      expect(
        () =>
            firestoreService.removeUserFromDespensa(testUserId, testDespensaId),
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
      when(mockFirestore.runTransaction(any)).thenAnswer((invocation) async {
        final transactionCallback = invocation.positionalArguments.first
            as Future<void> Function(Transaction);
        await transactionCallback(mockTransaction);
      });

      when(mockTransaction.delete(mockUsuarioDoc))
          .thenThrow(FirebaseException(plugin: 'firestore'));
      when(mockTransaction.delete(mockUserDespensaDoc))
          .thenReturn(mockTransaction);

      expect(
        () =>
            firestoreService.removeUserFromDespensa(testUserId, testDespensaId),
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
      when(mockFirestore.runTransaction(any)).thenAnswer((invocation) async {
        final transactionCallback = invocation.positionalArguments.first
            as Future<void> Function(Transaction);
        await transactionCallback(mockTransaction);
      });

      when(mockTransaction.delete(mockUsuarioDoc)).thenReturn(mockTransaction);
      when(mockTransaction.delete(mockUserDespensaDoc))
          .thenThrow(FirebaseException(plugin: 'firestore'));

      expect(
        () =>
            firestoreService.removeUserFromDespensa(testUserId, testDespensaId),
        throwsA(isA<FirestoreException>()),
      );

      verify(mockFirestore.runTransaction(any)).called(1);
      verify(mockTransaction.delete(mockUsuarioDoc)).called(1);
      verify(mockTransaction.delete(mockUserDespensaDoc)).called(1);
    });
  });
}
