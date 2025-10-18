import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:repondo/core/exceptions/firestore_mapper_exception.dart';
import 'package:repondo/core/firebase/retry_reader.dart';
import 'package:repondo/core/log/exports.dart';
import 'package:repondo/core/result/exports.dart';
import 'package:repondo/features/despensa/data/constants/exports.dart';
import 'package:repondo/features/despensa/data/exceptions/firebase_despensa_exception_mapper.dart';
import 'package:repondo/features/despensa/data/model/despensa_model.dart';
import 'package:repondo/features/despensa/domain/entities/despensa.dart';
import 'package:repondo/features/despensa/domain/exceptions/despensa_exception.dart';
import 'package:repondo/features/despensa/domain/params/create_despensa_params.dart';
import 'package:repondo/features/despensa/domain/repositories/despensa_repository.dart';

class FirebaseDespensaRepository implements DespensaRepository {
  final FirebaseFirestore _firestore;
  final AppLogger _logger;

  FirebaseDespensaRepository(
      {FirebaseFirestore? firestore, required AppLogger logger})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _logger = logger;

  @override
  Future<Result<Despensa, DespensaException>> addMember(
      String despensaId, String userId) {
    // TODO: implement addMember
    throw UnimplementedError();
  }

  @override
  Future<Result<Despensa, DespensaException>> createDespensa({
    required CreateDespensaParams params,
  }) async {
    return runCatching(() async {
      _logger.info('Iniciando criação da despensa com os parâmetros: $params');

      final despensaModel = DespensaModel.fromCreateParams(params);
      final now = FieldValue.serverTimestamp();
      final despensaMap = {
        ...despensaModel.toMap(),
        DespensaFirestoreKeys.createdAt: now,
        DespensaFirestoreKeys.updatedAt: now,
      };
      final despensaRef = await _firestore
          .collection(DespensaFirestoreKeys.collectionName)
          .add(despensaMap);

      _logger.info('Despensa criada com sucesso: ${despensaRef.id}');

      // Retry para garantir carregamento dos dados da despensa
      final resultRetry =
          await fetchWithRetry(docRef: despensaRef, logger: _logger);
      final data = resultRetry.fold(
        (error) {
          _logger.warning('Dados da despensa não encontrados após criação.');
          throw DespensaException(DespensaErrorMessages.fetchAfterCreateError);
        },
        (data) => data,
      );

      final savedDespensaModel = DespensaModel.fromMap(data, despensaRef.id);
      _logger.info('Despensa salva com sucesso: ${savedDespensaModel.id}');

      return savedDespensaModel.toEntity();
    }, (error) {
      _logger.error('Erro ao criar despensa', error, StackTrace.current);

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
  Future<Result<Despensa, DespensaException>> fetchDespensaById({
    required String despensaId,
  }) {
    return runCatching(() async {
      _logger.info('Iniciando busca da despensa pelo ID: $despensaId');

      final despensaRef = _firestore
          .collection(DespensaFirestoreKeys.collectionName)
          .doc(despensaId);

      // Retry para garantir carregamento dos dados da despensa
      final resultRetry =
          await fetchWithRetry(docRef: despensaRef, logger: _logger);
      final data = resultRetry.fold(
        (error) {
          _logger.error('Despensa não encontrada: $despensaId');
          throw DespensaException(DespensaErrorMessages.despensaNotFound);
        },
        (data) => data,
      );

      final despensaModel = DespensaModel.fromMap(data, despensaRef.id);
      _logger.info('Despensa encontrada com sucesso: ${despensaModel.id}');

      return despensaModel.toEntity();
    }, (error) {
      _logger.error('Erro ao buscar despensa', error, StackTrace.current);

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
          'Erro ao buscar despensa: ${DespensaErrorMessages.despensaUnknownError}');
    });
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
    return runCatching(() async {
      _logger.info('Iniciando atualização da despensa');

      final despensaModel = DespensaModel.fromEntity(despensa);
      final despensaRef = _firestore
          .collection(DespensaFirestoreKeys.collectionName)
          .doc(despensa.id);
      final despensaSnapshot = await despensaRef.get();
      if (!despensaSnapshot.exists) {
        _logger.error('Despensa não encontrada: ${despensa.id}');
        throw DespensaException(DespensaErrorMessages.despensaNotFound);
      }
      final despensaMap = {
        ...despensaModel.toMap(),
        DespensaFirestoreKeys.updatedAt: FieldValue.serverTimestamp(),
      };
      await despensaRef.update(despensaMap);
      _logger.info(
          'Despensa atualizada no firestore com sucesso: ${despensaRef.id}');

      // Retry para garantir carregamento dos dados da despensa
      final resultRetry =
          await fetchWithRetry(docRef: despensaRef, logger: _logger);
      final data = resultRetry.fold(
        (error) {
          _logger
              .warning('Dados da despensa não encontrados após atualização.');
          throw DespensaException(DespensaErrorMessages.fetchAfterUpdateError);
        },
        (data) => data,
      );

      final updatedDespensaModel = DespensaModel.fromMap(data, despensaRef.id);
      _logger.info(
          'Finalizado atualização da despensa: ${updatedDespensaModel.id}');

      return updatedDespensaModel.toEntity();
    }, (error) {
      _logger.error('Erro ao atualizar despensa', error, StackTrace.current);

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
          'Erro ao atualizar despensa: ${DespensaErrorMessages.despensaUnknownError}');
    });
  }
}
