import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:repondo/core/result/result.dart';
import 'package:repondo/features/despensa/data/constants/despensa_error_messages.dart';
import 'package:repondo/features/despensa/data/constants/despensa_firestore_keys.dart';
import 'package:repondo/features/despensa/data/model/despensa_model.dart';
import 'package:repondo/features/despensa/data/repositories/firebase_despensa_repository.dart';
import 'package:repondo/features/despensa/domain/entities/despensa.dart';
import 'package:repondo/features/despensa/domain/exceptions/despensa_exception.dart';

import '../../../../../mocks/mocks.mocks.dart';
import '../../../mocks/despensa_test_factory.dart';
import '../../../mocks/firebase_despensa_repository_mocks.mocks.dart';

void main() {
  const plugin = 'firestore';
  const logStart = 'Iniciando busca da despensa';
  const logSuccess = 'Despensa encontrada com sucesso';
  const logAttempt = 'Tentativa';
  const logError = 'Erro ao buscar despensa';
  const logErrorNotFound = 'Despensa não encontrada';
  const logErrorRetry = 'Erro ao buscar dados do documento';

  group('FirebaseDespensaRepository.fetchDespensaById', () {
    late MockFirebaseFirestore mockFirestore;
    late MockAppLogger mockLogger;
    late MockCollectionReference<Map<String, dynamic>> mockCollectionDespensas;
    late MockDocumentReference<Map<String, dynamic>> mockDocReferenceDespensa;
    late MockDocumentSnapshot<Map<String, dynamic>> mockSnapshotDespensa;
    late FirebaseDespensaRepository repository;

    late Despensa expectedDespensa;
    late Map<String, dynamic> fetchDespensaMap;

    setUp(() {
      mockFirestore = MockFirebaseFirestore();
      mockLogger = MockAppLogger();
      mockCollectionDespensas = MockCollectionReference();
      mockDocReferenceDespensa = MockDocumentReference();
      mockSnapshotDespensa = MockDocumentSnapshot();

      repository = FirebaseDespensaRepository(
        firestore: mockFirestore,
        logger: mockLogger,
      );

      expectedDespensa = DespensaTestFactory.create();
      fetchDespensaMap = DespensaModel.fromEntity(expectedDespensa).toMap();

      when(mockFirestore.collection(DespensaFirestoreKeys.collectionName))
          .thenReturn(mockCollectionDespensas);
      when(mockCollectionDespensas.doc(expectedDespensa.id))
          .thenReturn(mockDocReferenceDespensa);
      when(mockDocReferenceDespensa.id).thenReturn(expectedDespensa.id);
      when(mockDocReferenceDespensa.get())
          .thenAnswer((_) async => mockSnapshotDespensa);
      when(mockSnapshotDespensa.exists).thenReturn(true);
      when(mockSnapshotDespensa.data()).thenReturn(fetchDespensaMap);
    });

    group('casos de sucesso', () {
      test(
          'deve buscar a despensa com sucesso e retornar Success<Despensa, DespensaException>',
          () async {
        // act
        final result =
            await repository.fetchDespensaById(despensaId: expectedDespensa.id);

        // Verificação do retorno
        expect(result, isA<Success<Despensa, DespensaException>>());
        final data = result.data;
        expect(data, isA<Despensa>());
        expect(data, equals(expectedDespensa));

        verify(mockFirestore.collection(DespensaFirestoreKeys.collectionName))
            .called(1);
        verify(mockCollectionDespensas.doc(expectedDespensa.id)).called(1);
        verify(mockDocReferenceDespensa.get()).called(1);
        verify(mockDocReferenceDespensa.id).called(1);
        verify(mockSnapshotDespensa.exists).called(1);
        verify(mockSnapshotDespensa.data()).called(1);

        // Verificação dos logs
        verifyInOrder([
          mockLogger.info(argThat(contains(logStart))),
          mockLogger.info(argThat(contains(logSuccess))),
        ]);
        verifyNever(mockLogger.error(any, any, any));

        verifyNoMoreInteractions(mockFirestore);
        verifyNoMoreInteractions(mockCollectionDespensas);
        verifyNoMoreInteractions(mockDocReferenceDespensa);
        verifyNoMoreInteractions(mockSnapshotDespensa);
        verifyNoMoreInteractions(mockLogger);
      });

      test('deve fazer até 5 tentativas de leitura até encontrar dados válidos',
          () async {
        // Simula: null, empty, null, depois retorna dados válidos
        final dataResponses = [
          null,
          <String, dynamic>{},
          null,
          <String, dynamic>{},
          fetchDespensaMap,
        ];

        final dataResponsesQueue = Queue<Map<String, dynamic>?>();
        dataResponsesQueue.addAll(dataResponses);

        when(mockSnapshotDespensa.data()).thenAnswer((_) {
          return dataResponsesQueue.removeFirst();
        });

        final result =
            await repository.fetchDespensaById(despensaId: expectedDespensa.id);

        // Verificação do retorno
        expect(result, isA<Success<Despensa, DespensaException>>());
        final data = result.data;
        expect(data, isA<Despensa>());
        expect(data, equals(expectedDespensa));

        verify(mockFirestore.collection(DespensaFirestoreKeys.collectionName))
            .called(1);
        verify(mockCollectionDespensas.doc(expectedDespensa.id)).called(1);
        verify(mockDocReferenceDespensa.get()).called(5);
        verify(mockDocReferenceDespensa.id).called(3);
        verify(mockSnapshotDespensa.exists).called(5);
        verify(mockSnapshotDespensa.data()).called(5);

        verifyInOrder([
          mockLogger.info(argThat(contains(logStart))),
          mockLogger.warning(argThat(contains(logAttempt))),
          mockLogger.warning(argThat(contains(logAttempt))),
          mockLogger.info(argThat(contains(logSuccess))),
        ]);
        verifyNever(mockLogger.error(any, any, any));

        verifyNoMoreInteractions(mockFirestore);
        verifyNoMoreInteractions(mockCollectionDespensas);
        verifyNoMoreInteractions(mockDocReferenceDespensa);
        verifyNoMoreInteractions(mockSnapshotDespensa);
        verifyNoMoreInteractions(mockLogger);
      });
    });

    group('casos de erro', () {
      test(
          'deve retornar Failure ao lançar FirebaseException na busca da despensa por id',
          () async {
        // arrange
        const code = 'permission-denied';

        when(mockDocReferenceDespensa.id).thenReturn(expectedDespensa.id);

        when(mockDocReferenceDespensa.get())
            .thenThrow(FirebaseException(plugin: plugin, code: code));

        when(mockDocReferenceDespensa.get())
            .thenThrow(FirebaseException(plugin: plugin, code: code));

        // act
        final result =
            await repository.fetchDespensaById(despensaId: expectedDespensa.id);

        // assert
        expect(result, isA<Failure<Despensa, DespensaException>>());
        final error = result.error!;
        expect(error, isA<DespensaException>());
        expect(error.message, contains(DespensaErrorMessages.despensaNotFound));

        verify(mockFirestore.collection(DespensaFirestoreKeys.collectionName))
            .called(1);
        verify(mockCollectionDespensas.doc(expectedDespensa.id)).called(1);
        verify(mockDocReferenceDespensa.get()).called(1);
        verify(mockDocReferenceDespensa.id).called(1);
        verifyNever(mockSnapshotDespensa.exists);

        verifyInOrder([
          mockLogger.info(argThat(contains(logStart))),
          mockLogger.error(argThat(contains(logErrorRetry)), any, any),
          mockLogger.error(argThat(contains(logErrorNotFound)), any, any),
          mockLogger.error(argThat(contains(logError)), any, any),
        ]);

        verifyNoMoreInteractions(mockFirestore);
        verifyNoMoreInteractions(mockCollectionDespensas);
        verifyNoMoreInteractions(mockDocReferenceDespensa);
        verifyNoMoreInteractions(mockSnapshotDespensa);
        verifyNoMoreInteractions(mockLogger);
      });

      test(
          'deve retornar Failure ao lançar Exception genérica na busca da despensa por id',
          () async {
        // arrange
        const message = 'Erro inesperado';
        when(mockDocReferenceDespensa.get()).thenThrow(Exception(message));

        // act
        final result =
            await repository.fetchDespensaById(despensaId: expectedDespensa.id);

        // assert
        expect(result, isA<Failure<Despensa, DespensaException>>());
        final error = result.error!;
        expect(error, isA<DespensaException>());
        expect(error.message, contains(DespensaErrorMessages.despensaNotFound));

        verify(mockFirestore.collection(DespensaFirestoreKeys.collectionName))
            .called(1);
        verify(mockCollectionDespensas.doc(expectedDespensa.id)).called(1);
        verify(mockDocReferenceDespensa.get()).called(1);
        verify(mockDocReferenceDespensa.id).called(1);

        verifyInOrder([
          mockLogger.info(argThat(contains(logStart))),
          mockLogger.error(argThat(contains(logErrorRetry)), any, any),
          mockLogger.error(argThat(contains(logErrorNotFound)), any, any),
          mockLogger.error(argThat(contains(logError)), any, any),
        ]);

        verifyNoMoreInteractions(mockFirestore);
        verifyNoMoreInteractions(mockCollectionDespensas);
        verifyNoMoreInteractions(mockDocReferenceDespensa);
        verifyNoMoreInteractions(mockSnapshotDespensa);
        verifyNoMoreInteractions(mockLogger);
      });
    });
  });
}
