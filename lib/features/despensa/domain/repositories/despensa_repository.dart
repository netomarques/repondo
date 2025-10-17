import 'package:repondo/core/result/result.dart';
import 'package:repondo/features/despensa/domain/entities/despensa.dart';
import 'package:repondo/features/despensa/domain/exceptions/despensa_exception.dart';
import 'package:repondo/features/despensa/domain/params/create_despensa_params.dart';

abstract class DespensaRepository {
  Future<Result<Despensa, DespensaException>> createDespensa(
      CreateDespensaParams params);
  Future<Result<Despensa, DespensaException>> deleteDespensa(String id);
  Future<Result<Despensa, DespensaException>> updateDespensa(Despensa despensa);
  Future<Result<Despensa, DespensaException>> fetchDespensaById({
    required String despensaId,
  });
  Future<Result<Despensa, DespensaException>> fetchAllByUser(String userId);
  Future<Result<Despensa, DespensaException>> addMember(
      String despensaId, String userId);
  Future<Result<Despensa, DespensaException>> removeMember(
      String despensaId, String userId);
  Future<Result<Despensa, DespensaException>> isUserAdmin(
      String despensaId, String userId);
}
