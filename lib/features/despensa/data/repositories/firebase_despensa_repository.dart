import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:repondo/core/exceptions/firestore_mapper_exception.dart';
import 'package:repondo/core/result/result.dart';
import 'package:repondo/core/result/result_helpers.dart';
import 'package:repondo/features/despensa/data/constants/exports.dart';
import 'package:repondo/features/despensa/data/exceptions/firebase_despensa_exception_mapper.dart';
import 'package:repondo/features/despensa/data/model/despensa_model.dart';
import 'package:repondo/features/despensa/domain/entities/despensa.dart';
import 'package:repondo/features/despensa/domain/exceptions/despensa_exception.dart';
import 'package:repondo/features/despensa/domain/params/create_despensa_params.dart';
import 'package:repondo/features/despensa/domain/repositories/despensa_repository.dart';

class FirebaseDespensaRepository implements DespensaRepository {
  final FirebaseFirestore _firestore;

  FirebaseDespensaRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<Result<Despensa, DespensaException>> addMember(
      String despensaId, String userId) {
    // TODO: implement addMember
    throw UnimplementedError();
  }

  @override
  Future<Result<Despensa, DespensaException>> createDespensa(
      CreateDespensaParams params) async {
    return runCatching(() async {
      final despensaModel = DespensaModel.fromCreateParams(params);
      final despensaRef = await _firestore
          .collection(DespensaFirestoreKeys.collectionName)
          .add({
        ...despensaModel.toMap(),
        DespensaFirestoreKeys.createdAt: FieldValue.serverTimestamp(),
        DespensaFirestoreKeys.updatedAt: FieldValue.serverTimestamp(),
      });

      // Retry para garantir que os campos foram persistidos
      const maxRetries = 5;
      const delayBetweenRetries = Duration(milliseconds: 200);
      Map<String, dynamic>? data;

      for (var i = 0; i < maxRetries; i++) {
        final snapshot = await despensaRef.get();
        data = snapshot.data();

        if (data != null && data.isNotEmpty) break;
        await Future.delayed(delayBetweenRetries);
      }

      if (data == null || data.isEmpty) {
        throw DespensaException(DespensaErrorMessages.fetchAfterCreateError);
      }

      final savedDespensaModel = DespensaModel.fromMap(data, despensaRef.id);
      return savedDespensaModel.toEntity();
    }, (error) {
      if (error is DespensaException) {
        return error;
      }
      if (error is FirestoreMapperException) {
        return DespensaException(
            'Erro ao mapear dados da despensa: ${error.message}');
      }
      if (error is FirebaseException) {
        return fromFirebaseDespensaExceptionMapper(error);
      }

      return DespensaException(
          'Erro ao criar despensa: ${DespensaErrorMessages.despensaUnknownError}');
    });
  }

  @override
  Future<Result<Despensa, DespensaException>> deleteDespensa(String id) {
    // TODO: implement deleteDespensa
    throw UnimplementedError();
  }

  @override
  Future<Result<Despensa, DespensaException>> fetchAllByUser(String userId) {
    // TODO: implement fetchAllByUser
    throw UnimplementedError();
  }

  @override
  Future<Result<Despensa, DespensaException>> fetchDespensaById(String id) {
    // TODO: implement fetchDespensaById
    throw UnimplementedError();
  }

  @override
  Future<Result<Despensa, DespensaException>> isUserAdmin(
      String despensaId, String userId) {
    // TODO: implement isUserAdmin
    throw UnimplementedError();
  }

  @override
  Future<Result<Despensa, DespensaException>> removeMember(
      String despensaId, String userId) {
    // TODO: implement removeMember
    throw UnimplementedError();
  }

  @override
  Future<Result<Despensa, DespensaException>> updateDespensa(
      Despensa despensa) {
    // TODO: implement updateDespensa
    throw UnimplementedError();
  }
}
