import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:repondo/core/result/result.dart';
import 'package:repondo/features/despensa/data/constants/exports.dart';
import 'package:repondo/features/despensa/data/model/despensa_model.dart';
import 'package:repondo/features/despensa/data/repositories/firebase_despensa_repository.dart';
import 'package:repondo/features/despensa/domain/entities/despensa.dart';
import 'package:repondo/features/despensa/domain/exceptions/despensa_exception.dart';

import '../../../../../mocks/mocks.mocks.dart';
import '../../../mocks/despensa_test_factory.dart';
import '../../../mocks/firebase_despensa_repository_mocks.mocks.dart';

void main() {
  const plugin = 'firestore';
  const logStart = 'Iniciando atualização da despensa';
  const logSuccess = 'Despensa atualizada no firestore com sucesso';
  const logFinish = 'Finalizado atualização da despensa';
  const logError = 'Erro ao atualizar despensa';
  const logAttempt = 'Tentativa';
  const expectedName = 'Despensa Atualizada';

  group('FirebaseDespensaRepository.updateDespensa', () {
    late MockFirebaseFirestore mockFirestore;
    late MockAppLogger mockLogger;
    late MockCollectionReference<Map<String, dynamic>> mockCollectionDespensas;
    late MockDocumentReference<Map<String, dynamic>> mockDocReferenceDespensa;
    late Queue<MockDocumentSnapshot<Map<String, dynamic>>> snapshotQueue;
    late MockDocumentSnapshot<Map<String, dynamic>> mockSnapshotBefore;
    late MockDocumentSnapshot<Map<String, dynamic>> mockSnapshotAfter;
    late List<Map<String, dynamic>> capturedUpdateData;
    late FirebaseDespensaRepository repository;

    late Despensa despensa;
    late Despensa expectedDespensa;
    late Map<String, dynamic> updatedDespensaMap;

    setUp(() {
      mockFirestore = MockFirebaseFirestore();
      mockLogger = MockAppLogger();
      mockCollectionDespensas = MockCollectionReference();
      mockDocReferenceDespensa = MockDocumentReference();

      repository = FirebaseDespensaRepository(
          firestore: mockFirestore, logger: mockLogger);

      despensa = DespensaTestFactory.create();
      expectedDespensa = DespensaTestFactory.create(name: expectedName);
      updatedDespensaMap = DespensaModel.fromEntity(expectedDespensa).toMap();

      // Snapshot before
      mockSnapshotBefore = MockDocumentSnapshot();
      when(mockSnapshotBefore.exists).thenReturn(true);

      // Snapshot after
      mockSnapshotAfter = MockDocumentSnapshot();
      when(mockSnapshotAfter.exists).thenReturn(true);
      when(mockSnapshotAfter.data()).thenReturn(updatedDespensaMap);

      when(mockFirestore.collection(DespensaFirestoreKeys.collectionName))
          .thenReturn(mockCollectionDespensas);
      when(mockCollectionDespensas.doc(expectedDespensa.id))
          .thenReturn(mockDocReferenceDespensa);
      when(mockDocReferenceDespensa.id).thenReturn(despensa.id);

      snapshotQueue = Queue<MockDocumentSnapshot<Map<String, dynamic>>>();
      snapshotQueue.addAll([mockSnapshotBefore, mockSnapshotAfter]);
      when(mockDocReferenceDespensa.get())
          .thenAnswer((_) async => snapshotQueue.removeFirst());

      capturedUpdateData = <Map<String, dynamic>>[];
      when(mockDocReferenceDespensa.update(captureAny))
          .thenAnswer((invocation) async {
        capturedUpdateData.add(invocation.positionalArguments.first);
        return Future.value();
      });
    });

    group('casos de sucesso', () {
      test(
          'deve atualizar a despensa com sucesso e retornar Success<Despensa, DespensaException>',
          () async {
        const nameModified = 'Despensa Atualizada';

        // arrange
        final testDespensa = DespensaTestFactory.create(name: nameModified);

        // act
        final result = await repository.updateDespensa(testDespensa);

        // Verificação do retorno
        expect(result, isA<Success<Despensa, DespensaException>>());
        final data = result.data;
        expect(data, isA<Despensa>());
        expect(data, equals(expectedDespensa));

        // Validação dos dados enviados no update
        final updateMap = capturedUpdateData.single;
        expect(updateMap[DespensaFirestoreKeys.name], equals(nameModified));
        expect(updateMap, contains(DespensaFirestoreKeys.updatedAt));
        expect(updateMap[DespensaFirestoreKeys.updatedAt], isA<FieldValue>());
        expect(
            updateMap.keys,
            containsAll(
                [DespensaFirestoreKeys.name, DespensaFirestoreKeys.updatedAt]));

        verify(mockFirestore.collection(DespensaFirestoreKeys.collectionName))
            .called(1);
        verify(mockCollectionDespensas.doc(despensa.id)).called(1);
        verify(mockDocReferenceDespensa.get()).called(2);
        verify(mockSnapshotBefore.exists).called(1);
        verify(mockSnapshotAfter.data()).called(1);
        verify(mockSnapshotAfter.exists).called(1);
        verify(mockDocReferenceDespensa.id).called(2);
        verify(mockDocReferenceDespensa.update(captureAny)).called(1);

        // Verificação dos logs
        verifyInOrder([
          mockLogger.info(argThat(contains(logStart))),
          mockLogger.info(argThat(contains(logSuccess))),
          mockLogger.info(argThat(contains(logFinish))),
        ]);
        verifyNever(mockLogger.error(any, any, any));

        verifyNoMoreInteractions(mockFirestore);
        verifyNoMoreInteractions(mockCollectionDespensas);
        verifyNoMoreInteractions(mockDocReferenceDespensa);
        verifyNoMoreInteractions(mockSnapshotBefore);
        verifyNoMoreInteractions(mockSnapshotAfter);
        verifyNoMoreInteractions(mockLogger);
      });

      test(
          'deve fazer até 5 tentativas de leitura após update até encontrar dados válidos',
          () async {
        const nameModified = 'Despensa Atualizada';

        // Simula: null, empty, null, depois retorna dados válidos
        final dataResponses = [
          null,
          <String, dynamic>{},
          null,
          <String, dynamic>{},
          updatedDespensaMap
        ];

        final dataResponsesQueue = Queue<Map<String, dynamic>?>();
        dataResponsesQueue.addAll(dataResponses);

        when(mockSnapshotAfter.data()).thenAnswer((_) {
          if (dataResponsesQueue.length > 1) {
            snapshotQueue.add(mockSnapshotAfter);
          }
          return dataResponsesQueue.removeFirst();
        });

        final testDespensa = DespensaTestFactory.create(name: nameModified);
        final result = await repository.updateDespensa(testDespensa);

        // Verificação do retorno
        expect(result, isA<Success<Despensa, DespensaException>>());
        final data = result.data;
        expect(data, isA<Despensa>());
        expect(data, equals(expectedDespensa));

        // Validação dos dados enviados no update
        final updateMap = capturedUpdateData.single;
        expect(updateMap[DespensaFirestoreKeys.name], equals(nameModified));
        expect(updateMap, contains(DespensaFirestoreKeys.updatedAt));
        expect(updateMap[DespensaFirestoreKeys.updatedAt], isA<FieldValue>());
        expect(
            updateMap.keys,
            containsAll(
                [DespensaFirestoreKeys.name, DespensaFirestoreKeys.updatedAt]));

        verify(mockFirestore.collection(DespensaFirestoreKeys.collectionName))
            .called(1);
        verify(mockCollectionDespensas.doc(despensa.id)).called(1);
        verify(mockDocReferenceDespensa.get()).called(6);
        verify(mockSnapshotBefore.exists).called(1);
        verifyNever(mockSnapshotBefore.data());
        verify(mockSnapshotAfter.data()).called(5);
        verify(mockSnapshotAfter.exists).called(5);
        verify(mockDocReferenceDespensa.id).called(4);
        verify(mockDocReferenceDespensa.update(any)).called(1);

        verifyInOrder([
          mockLogger.info(argThat(contains(logStart))),
          mockLogger.info(argThat(contains(logSuccess))),
          mockLogger.warning(argThat(contains(logAttempt))),
          mockLogger.warning(argThat(contains(logAttempt))),
          mockLogger.info(argThat(contains(logFinish))),
        ]);
        verifyNever(mockLogger.error(any, any, any));

        verifyNoMoreInteractions(mockFirestore);
        verifyNoMoreInteractions(mockCollectionDespensas);
        verifyNoMoreInteractions(mockDocReferenceDespensa);
        verifyNoMoreInteractions(mockSnapshotBefore);
        verifyNoMoreInteractions(mockSnapshotAfter);
        verifyNoMoreInteractions(mockLogger);
      });
    });

    group('casos de erro', () {
      test(
          'deve retornar Failure ao lançar FirebaseException na atualização da despensa',
          () async {
        // arrange
        const code = 'permission-denied';
        final testDespensa = DespensaTestFactory.create(name: 'Atualizada');

        when(mockDocReferenceDespensa.update(any))
            .thenThrow(FirebaseException(plugin: plugin, code: code));

        // act
        final result = await repository.updateDespensa(testDespensa);

        // assert
        expect(result, isA<Failure<Despensa, DespensaException>>());
        final error = result.error!;
        expect(error, isA<DespensaException>());
        expect(error.message, contains(DespensaErrorMessages.permissionDenied));

        verify(mockFirestore.collection(DespensaFirestoreKeys.collectionName))
            .called(1);
        verify(mockCollectionDespensas.doc(despensa.id)).called(1);
        verify(mockDocReferenceDespensa.get()).called(1);
        verify(mockSnapshotBefore.exists).called(1);
        verify(mockDocReferenceDespensa.update(any)).called(1);

        verifyInOrder([
          mockLogger.info(argThat(contains(logStart))),
          mockLogger.error(argThat(contains(logError)), any, any),
        ]);

        verifyNoMoreInteractions(mockFirestore);
        verifyNoMoreInteractions(mockCollectionDespensas);
        verifyNoMoreInteractions(mockDocReferenceDespensa);
        verifyNoMoreInteractions(mockSnapshotBefore);
        verifyNoMoreInteractions(mockSnapshotAfter);
        verifyNoMoreInteractions(mockLogger);
      });

      test(
          'deve retornar Failure ao lançar Exception genérica na atualização da despensa',
          () async {
        // arrange
        const message = 'Erro inesperado';
        when(mockDocReferenceDespensa.update(any))
            .thenThrow(Exception(message));

        // act
        final result = await repository.updateDespensa(despensa);

        // assert
        expect(result, isA<Failure<Despensa, DespensaException>>());
        final error = result.error!;
        expect(error, isA<DespensaException>());
        expect(error.message,
            contains(DespensaErrorMessages.despensaUnknownError));

        verify(mockFirestore.collection(DespensaFirestoreKeys.collectionName))
            .called(1);
        verify(mockCollectionDespensas.doc(despensa.id)).called(1);
        verify(mockDocReferenceDespensa.update(any)).called(1);
        verify(mockDocReferenceDespensa.get()).called(1);
        verify(mockSnapshotBefore.exists).called(1);

        verifyInOrder([
          mockLogger.info(argThat(contains(logStart))),
          mockLogger.error(argThat(contains(logError)), any, any),
        ]);

        verifyNoMoreInteractions(mockFirestore);
        verifyNoMoreInteractions(mockCollectionDespensas);
        verifyNoMoreInteractions(mockDocReferenceDespensa);
        verifyNoMoreInteractions(mockSnapshotBefore);
        verifyNoMoreInteractions(mockSnapshotAfter);
        verifyNoMoreInteractions(mockLogger);
      });

      test('deve retornar Failure quando a despensa não existir no Firestore',
          () async {
        const logDespensaNotFound = 'Despensa não encontrada';

        when(mockSnapshotBefore.exists).thenReturn(false);
        final result = await repository.updateDespensa(despensa);

        expect(result, isA<Failure<Despensa, DespensaException>>());
        final error = result.error!;
        expect(error, isA<DespensaException>());
        expect(error.message, contains(DespensaErrorMessages.despensaNotFound));

        verify(mockFirestore.collection(DespensaFirestoreKeys.collectionName))
            .called(1);
        verify(mockCollectionDespensas.doc(despensa.id)).called(1);
        verify(mockDocReferenceDespensa.get()).called(1);
        verify(mockSnapshotBefore.exists).called(1);

        verifyInOrder([
          mockLogger.info(argThat(contains(logStart))),
          mockLogger.error(argThat(contains(logDespensaNotFound)), any, any),
          mockLogger.error(argThat(contains(logError)), any, any),
        ]);

        verifyNoMoreInteractions(mockFirestore);
        verifyNoMoreInteractions(mockCollectionDespensas);
        verifyNoMoreInteractions(mockDocReferenceDespensa);
        verifyNoMoreInteractions(mockSnapshotBefore);
        verifyNoMoreInteractions(mockSnapshotAfter);
        verifyNoMoreInteractions(mockLogger);
      });
    });
  });
}
