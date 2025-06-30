import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:repondo/core/result/result.dart';
import 'package:repondo/features/despensa/data/constants/exports.dart';
import 'package:repondo/features/despensa/data/model/despensa_model.dart';
import 'package:repondo/features/despensa/data/repositories/firebase_despensa_repository.dart';
import 'package:repondo/features/despensa/domain/entities/despensa.dart';
import 'package:repondo/features/despensa/domain/exceptions/despensa_exception.dart';
import 'package:repondo/features/despensa/domain/params/create_despensa_params.dart';

import '../../../../../mocks/mocks.mocks.dart';
import '../../../mocks/despensa_test_factory.dart';
import '../../../mocks/firebase_despensa_repository_mocks.mocks.dart';

void main() {
  const plugin = 'firestore';
  const despensaId = 'despensaId';
  const logStart = 'Iniciando criação da despensa';
  const logSuccess = 'Despensa criada com sucesso';
  const logSaved = 'Despensa salva com sucesso';
  const logFetchAfterCreateWarning =
      'Dados da despensa não encontrados após criação.';
  const logError = 'Erro ao criar despensa';

  group('FirebaseDespensaRepository.createDespensa', () {
    late MockFirebaseFirestore mockFirestore;
    late MockAppLogger mockLogger;
    late MockCollectionReference<Map<String, dynamic>> mockCollectionDespensas;
    late MockDocumentReference<Map<String, dynamic>> mockDocReferenceDespensa;
    late MockDocumentSnapshot<Map<String, dynamic>> mockSnapshotDespensa;
    late FirebaseDespensaRepository repository;

    late Map<String, dynamic> savedMap;
    late CreateDespensaParams params;
    late Despensa expectedDespensa;

    setUp(() {
      expectedDespensa = DespensaTestFactory.create();

      params = CreateDespensaParams(
        name: expectedDespensa.name,
        adminIds: expectedDespensa.adminIds,
        memberIds: expectedDespensa.memberIds,
      );

      savedMap = DespensaModel.fromEntity(DespensaTestFactory.create()).toMap();

      mockFirestore = MockFirebaseFirestore();
      mockLogger = MockAppLogger();
      mockCollectionDespensas = MockCollectionReference();
      mockDocReferenceDespensa = MockDocumentReference();
      mockSnapshotDespensa = MockDocumentSnapshot();

      repository = FirebaseDespensaRepository(
          firestore: mockFirestore, logger: mockLogger);

      when(mockFirestore.collection(DespensaFirestoreKeys.collectionName))
          .thenReturn(mockCollectionDespensas);
      when(mockCollectionDespensas.add(any))
          .thenAnswer((_) async => mockDocReferenceDespensa);
      when(mockDocReferenceDespensa.id).thenReturn(despensaId);
      when(mockDocReferenceDespensa.get())
          .thenAnswer((_) async => mockSnapshotDespensa);
      when(mockSnapshotDespensa.data()).thenReturn(savedMap);
    });

    group('casos de sucesso', () {
      test(
          'deve criar despensa com sucesso e retornar Success<Despensa, DespensaException>',
          () async {
        // act
        final result = await repository.createDespensa(params);

        // assert
        expect(result, isA<Success<Despensa, DespensaException>>());
        expect(result.data, isA<Despensa>());

        final despensa = result.data!;
        expect(despensa, equals(expectedDespensa));

        verify(mockFirestore.collection(DespensaFirestoreKeys.collectionName))
            .called(1);

        verify(mockCollectionDespensas.add(argThat(
          isA<Map<String, dynamic>>()
              .having((map) => map[DespensaFirestoreKeys.name],
                  DespensaFirestoreKeys.name, params.name)
              .having((map) => map[DespensaFirestoreKeys.adminIds],
                  DespensaFirestoreKeys.adminIds, params.adminIds)
              .having((map) => map[DespensaFirestoreKeys.memberIds],
                  DespensaFirestoreKeys.memberIds, params.memberIds),
        ))).called(1);

        verify(mockDocReferenceDespensa.get()).called(1);
        verify(mockDocReferenceDespensa.id).called(2);
        verify(mockSnapshotDespensa.data()).called(1);

        verifyInOrder([
          mockLogger.info(argThat(contains(logStart))),
          mockLogger.info(argThat(contains(logSuccess))),
          mockLogger.info(argThat(contains(logSaved))),
        ]);

        verifyNever(mockLogger.warning(any));
        verifyNever(mockLogger.error(any, any, any));

        verifyNoMoreInteractions(mockFirestore);
        verifyNoMoreInteractions(mockCollectionDespensas);
        verifyNoMoreInteractions(mockDocReferenceDespensa);
        verifyNoMoreInteractions(mockSnapshotDespensa);
        verifyNoMoreInteractions(mockLogger);
      });

      test(
          'deve tentar várias vezes buscar snapshot até encontrar dados válidos',
          () async {
        // Simula: null, empty, null, depois retorna dados válidos
        final dataResponses = [null, <String, dynamic>{}, null, savedMap];
        int callIndex = 0;
        when(mockDocReferenceDespensa.get()).thenAnswer((_) async {
          when(mockSnapshotDespensa.data())
              .thenReturn(dataResponses[callIndex++]);
          return mockSnapshotDespensa;
        });

        final result = await repository.createDespensa(params);

        // assert
        expect(result, isA<Success<Despensa, DespensaException>>());
        expect(result.data, isA<Despensa>());

        final despensa = result.data!;
        expect(despensa, equals(expectedDespensa));

        verify(mockFirestore.collection(DespensaFirestoreKeys.collectionName))
            .called(1);
        verify(mockCollectionDespensas.add(argThat(
          isA<Map<String, dynamic>>()
              .having((map) => map[DespensaFirestoreKeys.name],
                  DespensaFirestoreKeys.name, params.name)
              .having((map) => map[DespensaFirestoreKeys.adminIds],
                  DespensaFirestoreKeys.adminIds, params.adminIds)
              .having((map) => map[DespensaFirestoreKeys.memberIds],
                  DespensaFirestoreKeys.memberIds, params.memberIds),
        ))).called(1);
        verify(mockDocReferenceDespensa.get()).called(4);
        verify(mockSnapshotDespensa.data()).called(4);
        verify(mockDocReferenceDespensa.id).called(2);

        verifyInOrder([
          mockLogger.info(argThat(contains(logStart))),
          mockLogger.info(argThat(contains(logSuccess))),
          mockLogger.info(argThat(contains(logSaved))),
        ]);
        verifyNever(mockLogger.warning(any));
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
          'deve retornar Failure quando data do snapshot for null após 5 tentativas',
          () async {
        when(mockSnapshotDespensa.data()).thenReturn(null);

        final result = await repository.createDespensa(params);

        expect(result, isA<Failure<Despensa, DespensaException>>());
        expect(result.error, isA<DespensaException>());

        final error = result.error!;
        expect(error.message,
            contains(DespensaErrorMessages.fetchAfterCreateError));

        verify(mockFirestore.collection(DespensaFirestoreKeys.collectionName))
            .called(1);
        verify(mockCollectionDespensas.add(argThat(
          isA<Map<String, dynamic>>()
              .having(
                (map) => map[DespensaFirestoreKeys.name],
                DespensaFirestoreKeys.name,
                params.name,
              )
              .having(
                (map) => map[DespensaFirestoreKeys.adminIds],
                DespensaFirestoreKeys.adminIds,
                params.adminIds,
              )
              .having(
                (map) => map[DespensaFirestoreKeys.memberIds],
                DespensaFirestoreKeys.memberIds,
                params.memberIds,
              ),
        ))).called(1);
        verify(mockDocReferenceDespensa.id).called(1);
        verify(mockDocReferenceDespensa.get()).called(5);
        verify(mockSnapshotDespensa.data()).called(5);

        verifyInOrder([
          mockLogger.info(argThat(contains(logStart))),
          mockLogger.info(argThat(contains(logSuccess))),
          mockLogger.warning(argThat(contains(logFetchAfterCreateWarning))),
          mockLogger.error(argThat(contains(logError)), any, any),
        ]);

        verifyNoMoreInteractions(mockFirestore);
        verifyNoMoreInteractions(mockCollectionDespensas);
        verifyNoMoreInteractions(mockDocReferenceDespensa);
        verifyNoMoreInteractions(mockSnapshotDespensa);
        verifyNoMoreInteractions(mockLogger);
      });

      test('deve retornar Failure ao lançar FirebaseException na collection',
          () async {
        const code = 'unknown-error';

        // Arrange
        when(mockFirestore.collection(DespensaFirestoreKeys.collectionName))
            .thenThrow(
          FirebaseException(plugin: plugin, code: code),
        );

        // Act
        final result = await repository.createDespensa(params);

        // Assert
        expect(result, isA<Failure<Despensa, DespensaException>>());

        final error = result.error!;
        expect(error, isA<DespensaException>());
        expect(error.message,
            contains(DespensaErrorMessages.despensaUnknownError));

        verify(mockFirestore.collection(DespensaFirestoreKeys.collectionName))
            .called(1);
        verifyNever(mockCollectionDespensas.add(any));
        verifyNever(mockDocReferenceDespensa.get());
        verifyNever(mockSnapshotDespensa.data());

        verifyInOrder([
          mockLogger.info(argThat(contains(logStart))),
          mockLogger.error(argThat(contains(logError)), any, any),
        ]);

        verifyNoMoreInteractions(mockFirestore);
        verifyNoMoreInteractions(mockCollectionDespensas);
        verifyNoMoreInteractions(mockLogger);
      });

      test('deve retornar Failure ao lançar Exception inesperada na collection',
          () async {
        const message = 'Erro inesperado';

        when(mockFirestore.collection(DespensaFirestoreKeys.collectionName))
            .thenThrow(Exception(message));

        final result = await repository.createDespensa(params);

        expect(result, isA<Failure<Despensa, DespensaException>>());
        final error = result.error!;
        expect(error, isA<DespensaException>());
        expect(error.message,
            contains(DespensaErrorMessages.despensaUnknownError));

        verify(mockFirestore.collection(DespensaFirestoreKeys.collectionName))
            .called(1);
        verifyInOrder([
          mockLogger.info(argThat(contains(logStart))),
          mockLogger.error(argThat(contains(logError)), any, any),
        ]);

        verifyNever(mockCollectionDespensas.add(any));
        verifyNever(mockDocReferenceDespensa.get());
        verifyNever(mockSnapshotDespensa.data());

        verifyNoMoreInteractions(mockFirestore);
        verifyNoMoreInteractions(mockCollectionDespensas);
        verifyNoMoreInteractions(mockLogger);
      });

      test(
          'deve retornar Failure ao lançar FirebaseException no .get() do DocumentReference',
          () async {
        const code = 'permission-denied';

        when(mockDocReferenceDespensa.get())
            .thenThrow(FirebaseException(plugin: plugin, code: code));

        final result = await repository.createDespensa(params);

        expect(result, isA<Failure<Despensa, DespensaException>>());
        final error = result.error!;
        expect(error, isA<DespensaException>());
        expect(error.message, contains(DespensaErrorMessages.permissionDenied));

        verify(mockFirestore.collection(DespensaFirestoreKeys.collectionName))
            .called(1);
        verify(mockCollectionDespensas.add(any)).called(1);
        verify(mockDocReferenceDespensa.get()).called(1);

        verifyInOrder([
          mockLogger.info(argThat(contains(logStart))),
          mockLogger.info(argThat(contains(logSuccess))),
          mockLogger.error(argThat(contains(logError)), any, any),
        ]);

        verifyNever(mockSnapshotDespensa.data());

        verifyNoMoreInteractions(mockFirestore);
        verifyNoMoreInteractions(mockCollectionDespensas);
        verifyNoMoreInteractions(mockLogger);
      });
    });
  });
}
