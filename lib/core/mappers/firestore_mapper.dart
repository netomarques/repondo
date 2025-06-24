import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:repondo/core/exceptions/firestore_mapper_exception.dart';

final class FirestoreMapper {
  FirestoreMapper._();

  /// Retorna o valor do campo [key] no [map] com o tipo esperado [T].
  ///
  /// Lança [FirestoreMapperException] se o campo estiver ausente,
  /// for nulo ou não for do tipo [T].
  static T getRequired<T>(Map<String, dynamic> map, String key) {
    final value = map[key];

    if (value == null) {
      throw FirestoreMapperException('Campo "$key" não pode ser nulo');
    }

    if (value is! T) {
      throw FirestoreMapperException('Campo "$key" inválido ou ausente');
    }

    return value;
  }

  /// Retorna a lista do campo [key] no [map], garantindo que todos os elementos
  /// sejam do tipo [T].
  ///
  /// Lança [FirestoreMapperException] se o campo não for uma lista,
  /// estiver vazio ou contiver elementos de tipo inválido.
  static List<T> getRequiredList<T>(Map<String, dynamic> map, String key) {
    final value = map[key];

    if (value is! List) {
      throw FirestoreMapperException('Campo "$key" não é uma lista');
    }

    try {
      final list = List<T>.from(value);

      if (list.isEmpty) {
        throw FirestoreMapperException(
            'Campo "$key" não pode ser uma lista vazia');
      }

      return list;
    } catch (_) {
      throw FirestoreMapperException('Campo "$key" possui elementos inválidos');
    }
  }

  /// Retorna o valor do campo [key] no [map] convertido para [DateTime].
  ///
  /// Espera que o valor seja do tipo [Timestamp], lança
  /// [FirestoreMapperException] se o campo estiver ausente, nulo ou não for [Timestamp].
  static DateTime getRequiredDateTime(Map<String, dynamic> map, String key) {
    final value = map[key];

    if (value == null) {
      throw FirestoreMapperException('Campo "$key" é nulo');
    }

    if (value is! Timestamp) {
      throw FirestoreMapperException('Campo "$key" não é Timestamp');
    }

    return value.toDate();
  }
}
