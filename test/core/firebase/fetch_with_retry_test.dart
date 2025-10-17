import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:repondo/core/exceptions/document_not_found_exception.dart';
import 'package:repondo/core/exceptions/empty_document_exception.dart';
import 'package:repondo/core/exceptions/firebase_repository_exception.dart';
import 'package:repondo/core/exceptions/firestore_network_exception.dart';
import 'package:repondo/core/firebase/retry_reader.dart';
import 'package:repondo/core/result/result.dart';

import '../../features/despensa/mocks/firebase_despensa_repository_mocks.mocks.dart';
import '../../mocks/mocks.mocks.dart';

void main() {
  group('fetchWithRetry', () {
    late MockDocumentReference<Map<String, dynamic>> mockDocRef;
    late MockDocumentSnapshot<Map<String, dynamic>> mockSnapshot;
    late MockAppLogger mockLogger;

    const logAttemptWarning = 'Tentativa';
    const logError = 'Erro ao buscar dados do documento';
    const docId = '1a2b';

    setUp(() {
      mockDocRef = MockDocumentReference();
      mockSnapshot = MockDocumentSnapshot();
      mockLogger = MockAppLogger();
    });

    test('retorna dados quando snapshot existe e não está vazio', () async {
      const mapData = {'nome': 'Luffy'};

      when(mockDocRef.id).thenReturn(docId);
      when(mockDocRef.get()).thenAnswer((_) async => mockSnapshot);
      when(mockSnapshot.exists).thenReturn(true);
      when(mockSnapshot.data()).thenReturn(mapData);

      final result =
          await fetchWithRetry(docRef: mockDocRef, logger: mockLogger);

      expect(result,
          isA<Success<Map<String, dynamic>, FirebaseRepositoryException>>());
      expect(result.data, mapData);

      verify(mockDocRef.get()).called(1);
      verify(mockSnapshot.exists);
      verify(mockSnapshot.data()).called(1);

      verifyNoMoreInteractions(mockDocRef);
      verifyNoMoreInteractions(mockSnapshot);
    });

    test('lança DocumentNotFoundException quando snapshot não existe',
        () async {
      const mapData = {'nome': 'Luffy'};
      const docId = '1a2b';

      when(mockDocRef.id).thenReturn(docId);
      when(mockDocRef.get()).thenAnswer((_) async => mockSnapshot);
      when(mockSnapshot.exists).thenReturn(false);
      when(mockSnapshot.data()).thenReturn(mapData);

      final result =
          await fetchWithRetry(docRef: mockDocRef, logger: mockLogger);

      expect(result,
          isA<Failure<Map<String, dynamic>, FirebaseRepositoryException>>());
      expect(result.error, isA<DocumentNotFoundException>());

      verify(mockDocRef.get()).called(1);
      verify(mockDocRef.id).called(2);
      verify(mockLogger.warning(argThat(contains('não existe')))).called(1);
      verify(mockLogger.error(argThat(contains(logError)))).called(1);

      verifyNoMoreInteractions(mockDocRef);
      verifyNoMoreInteractions(mockLogger);
    });

    test('lança EmptyDocumentException quando snapshot vazio', () async {
      const docId = '1a2b';

      when(mockDocRef.id).thenReturn(docId);
      when(mockDocRef.get()).thenAnswer((_) async => mockSnapshot);
      when(mockSnapshot.exists).thenReturn(true);
      when(mockSnapshot.data()).thenReturn({}); // vazio

      final result = await fetchWithRetry(
        docRef: mockDocRef,
        logger: mockLogger,
        maxRetries: 2, // reduzido para teste
        delayBetweenRetries: Duration(milliseconds: 1),
      );

      expect(result,
          isA<Failure<Map<String, dynamic>, FirebaseRepositoryException>>());
      expect(result.error, isA<EmptyDocumentException>());

      verify(mockDocRef.get()).called(2);
      verify(mockDocRef.id).called(4);
      verify(mockLogger.warning(argThat(contains(logAttemptWarning))))
          .called(2);
      verify(mockLogger.info(argThat(contains('vazio')))).called(1);
      verify(mockLogger.error(argThat(contains(logError)))).called(1);

      verifyNoMoreInteractions(mockDocRef);
      verifyNoMoreInteractions(mockLogger);
    });

    test('lança FirestoreNetworkException após várias tentativas', () async {
      const logNetworkError = 'Erro de rede ao buscar dados do documento';

      when(mockDocRef.id).thenReturn(docId);
      when(mockDocRef.get()).thenThrow(
        FirebaseException(plugin: 'firestore', code: 'unavailable'),
      );

      final result = await fetchWithRetry(
        docRef: mockDocRef,
        logger: mockLogger,
        delayBetweenRetries: Duration(milliseconds: 1),
      );

      expect(result,
          isA<Failure<Map<String, dynamic>, FirebaseRepositoryException>>());
      expect(result.error, isA<FirestoreNetworkException>());

      verify(mockDocRef.get()).called(5);
      verify(mockDocRef.id).called(4);
      verifyInOrder([
        mockLogger.warning(argThat(contains(logAttemptWarning))),
        mockLogger.warning(argThat(contains(logAttemptWarning))),
        mockLogger.error(argThat(contains(logNetworkError))),
        mockLogger.error(argThat(contains(logError))),
      ]);

      verifyNoMoreInteractions(mockDocRef);
      verifyNoMoreInteractions(mockLogger);
    });

    test('lança FirebaseRepositoryException para outros erros', () async {
      const mapData = {'nome': 'Luffy'};
      const docId = '1a2b';

      when(mockDocRef.id).thenReturn(docId);
      when(mockDocRef.get()).thenThrow(
          FirebaseException(plugin: 'firestore', code: 'permission-denied'));
      when(mockSnapshot.exists).thenReturn(true);
      when(mockSnapshot.data()).thenReturn(mapData);

      final result = await fetchWithRetry(
        docRef: mockDocRef,
        logger: mockLogger,
        delayBetweenRetries: Duration(milliseconds: 1),
      );

      expect(result,
          isA<Failure<Map<String, dynamic>, FirebaseRepositoryException>>());
      expect(result.error, isA<FirebaseRepositoryException>());

      verify(mockDocRef.get()).called(1);
      verify(mockDocRef.id).called(1);
      verify(mockLogger.error(argThat(contains(logError)))).called(1);

      verifyNoMoreInteractions(mockDocRef);
      verifyNoMoreInteractions(mockLogger);
    });
  });
}
