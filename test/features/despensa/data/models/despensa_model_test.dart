import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:repondo/core/exceptions/firestore_mapper_exception.dart';
import 'package:repondo/features/despensa/data/constants/despensa_firestore_keys.dart';
import 'package:repondo/features/despensa/data/model/despensa_model.dart';
import 'package:repondo/features/despensa/domain/entities/despensa.dart';

import '../../mocks/despensa_model_test_factory.dart';
import '../../mocks/despensa_test_factory.dart';

void main() {
  group('DespensaModel', () {
    late DateTime now;
    late DespensaModel model;
    late Despensa entity;

    setUp(() {
      now = DateTime(2024, 6, 1, 12, 0);
      model = DespensaModelTestFactory.create();
      entity = DespensaTestFactory.create();
    });

    group('sucesso', () {
      test('Deve criar um DespensaModel válido a partir da função fromEntity',
          () {
        // Act
        final result = DespensaModel.fromEntity(entity);

        // Assert
        expect(result, isA<DespensaModel>());
        expect(result, equals(model));
      });

      test('Deve criar Despensa válido a partir da função toEntity', () {
        // Act
        final result = model.toEntity();

        // Assert
        expect(result, isA<Despensa>());
        expect(result, equals(entity));
      });

      test('Deve criar um Map válido para Firestore a partir da função toMap',
          () {
        // Act
        final map = model.toMap();

        // Assert
        expect(map[DespensaFirestoreKeys.name], equals('Despensa de teste'));
        expect(map[DespensaFirestoreKeys.inviteCode], equals('INV123'));
        expect(map[DespensaFirestoreKeys.adminIds], equals(['admin1']));
        expect(map[DespensaFirestoreKeys.memberIds],
            equals(['admin1', 'membro2']));
        expect(map[DespensaFirestoreKeys.createdAt], isA<Timestamp>());
        expect(map[DespensaFirestoreKeys.updatedAt], isA<Timestamp>());
      });

      test('Deve criar um DespensaModel a partir de um Map válido do Firestore',
          () {
        // Arrange
        final map = {
          DespensaFirestoreKeys.name: 'Despensa de teste',
          DespensaFirestoreKeys.inviteCode: 'INV123',
          DespensaFirestoreKeys.adminIds: ['admin1'],
          DespensaFirestoreKeys.memberIds: ['admin1', 'membro2'],
          DespensaFirestoreKeys.createdAt: Timestamp.fromDate(now),
          DespensaFirestoreKeys.updatedAt: Timestamp.fromDate(now),
        };

        // Act
        final result = DespensaModel.fromMap(map, 'despensaId');

        // Assert
        expect(result, isA<DespensaModel>());
        expect(result, equals(model));
      });
    });

    group('erro', () {
      test(
          'fromMap deve lançar exceção se campos obrigatórios estiverem ausentes',
          () {
        final invalidMap = {
          DespensaFirestoreKeys.name: 'Despensa de teste',
          // inviteCode ausente
          DespensaFirestoreKeys.adminIds: ['admin1'],
          DespensaFirestoreKeys.memberIds: ['admin1', 'membro2'],
          DespensaFirestoreKeys.createdAt: Timestamp.now(),
          DespensaFirestoreKeys.updatedAt: Timestamp.now(),
        };

        expect(
          () => DespensaModel.fromMap(invalidMap, 'despensaId'),
          throwsA(isA<FirestoreMapperException>()),
        );
      });

      test('fromMap deve lançar exceção se tipo de campo for errado', () {
        final invalidMap = {
          DespensaFirestoreKeys.name: 'Despensa de teste',
          DespensaFirestoreKeys.inviteCode: 123, // inviteCode deve ser String
          DespensaFirestoreKeys.adminIds: ['admin1'],
          DespensaFirestoreKeys.memberIds: ['admin1', 'membro2'],
          DespensaFirestoreKeys.createdAt: Timestamp.now(),
          DespensaFirestoreKeys.updatedAt: Timestamp.now(),
        };

        expect(
          () => DespensaModel.fromMap(invalidMap, 'despensaId'),
          throwsA(isA<FirestoreMapperException>()),
        );
      });

      test('fromMap deve lançar exceção se adminIds não for uma lista', () {
        final map = {
          DespensaFirestoreKeys.name: 'Despensa de teste',
          DespensaFirestoreKeys.inviteCode: 'INV123',
          DespensaFirestoreKeys.adminIds: 'admin1', // errado
          DespensaFirestoreKeys.memberIds: ['admin1', 'membro2'],
          DespensaFirestoreKeys.createdAt: Timestamp.now(),
          DespensaFirestoreKeys.updatedAt: Timestamp.now(),
        };

        expect(
          () => DespensaModel.fromMap(map, 'despensaId'),
          throwsA(isA<FirestoreMapperException>()),
        );
      });
    });
  });
}
