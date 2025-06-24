import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:repondo/core/exceptions/firestore_mapper_exception.dart';
import 'package:repondo/core/mappers/firestore_mapper.dart';

void main() {
  group('FirestoreMapper', () {
    late String keyString;
    late String keyList;
    late String keyTimestamp;
    late String validStringValue;
    late List<String> validStringList;
    late List<int> invalidTypedList;
    late DateTime validDateTimeValue;
    late Timestamp validTimestampValue;

    setUp(() {
      keyString = 'stringField';
      keyList = 'listField';
      keyTimestamp = 'timeStampField';
      validStringValue = 'SomeValue';
      validStringList = ['a', 'b'];
      invalidTypedList = [123, 456];
      validDateTimeValue = DateTime(2024, 1, 1);
      validTimestampValue = Timestamp.fromDate(validDateTimeValue);
    });

    group('FirestoreMapper.getRequired', () {
      group('Sucesso', () {
        test('retorna valor corretamente se tipo estiver certo', () {
          final map = {keyString: validStringValue};

          final result = FirestoreMapper.getRequired<String>(map, keyString);

          expect(result, validStringValue);
        });
      });

      group('Erro', () {
        test('lança exceção se tipo estiver errado', () {
          final map = {keyString: 123};

          expect(
            () => FirestoreMapper.getRequired<String>(map, keyString),
            throwsA(isA<FirestoreMapperException>()),
          );
        });

        test('lança exceção se valor for null', () {
          final map = {keyString: null};

          expect(
            () => FirestoreMapper.getRequired<String>(map, keyString),
            throwsA(isA<FirestoreMapperException>()),
          );
        });

        test('lança exceção se campo não existir', () {
          final Map<String, dynamic> map = {};

          expect(
            () => FirestoreMapper.getRequired<String>(map, keyString),
            throwsA(isA<FirestoreMapperException>()),
          );
        });
      });
    });

    group('FirestoreMapper.getRequiredList', () {
      group('Sucesso', () {
        test('retorna lista corretamente se tipos estiverem corretos', () {
          final map = {keyList: validStringList};

          final result = FirestoreMapper.getRequiredList<String>(map, keyList);

          expect(result, equals(validStringList));
        });
      });

      group('Erro', () {
        test('lança exceção se campo não for uma lista', () {
          final map = {keyList: 'notAList'};

          expect(
            () => FirestoreMapper.getRequiredList<String>(map, keyList),
            throwsA(isA<FirestoreMapperException>()),
          );
        });

        test('lança exceção se lista estiver vazia', () {
          final map = {keyList: []};

          expect(
            () => FirestoreMapper.getRequiredList<String>(map, keyList),
            throwsA(isA<FirestoreMapperException>()),
          );
        });

        test('lança exceção se lista contiver tipos inválidos', () {
          final map = {keyList: invalidTypedList};

          expect(
            () => FirestoreMapper.getRequiredList<String>(map, keyList),
            throwsA(isA<FirestoreMapperException>()),
          );
        });

        test('lança exceção se campo não existir', () {
          final Map<String, dynamic> map = {};

          expect(
            () => FirestoreMapper.getRequiredList<String>(map, keyList),
            throwsA(isA<FirestoreMapperException>()),
          );
        });

        test('lança exceção se campo for null', () {
          final map = {keyList: null};

          expect(
            () => FirestoreMapper.getRequiredList<String>(map, keyList),
            throwsA(isA<FirestoreMapperException>()),
          );
        });
      });
    });

    group('FirestoreMapper.getRequiredDateTime', () {
      test('retorna DateTime convertido corretamente', () {
        final map = {keyTimestamp: validTimestampValue};

        final result = FirestoreMapper.getRequiredDateTime(map, keyTimestamp);

        expect(result, validDateTimeValue);
      });

      test('lança exceção se campo for nulo', () {
        final map = {keyTimestamp: null};

        expect(
          () => FirestoreMapper.getRequiredDateTime(map, keyTimestamp),
          throwsA(isA<FirestoreMapperException>()),
        );
      });

      test('lança exceção se campo não for Timestamp', () {
        final map = {keyTimestamp: 'notATimestamp'};

        expect(
          () => FirestoreMapper.getRequiredDateTime(map, keyTimestamp),
          throwsA(isA<FirestoreMapperException>()),
        );
      });

      test('lança exceção se campo não existir', () {
        final Map<String, dynamic> map = {};

        expect(
          () => FirestoreMapper.getRequiredDateTime(map, keyTimestamp),
          throwsA(isA<FirestoreMapperException>()),
        );
      });
    });
  });
}
