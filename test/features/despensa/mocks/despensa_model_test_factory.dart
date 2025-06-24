import 'package:repondo/features/despensa/data/model/despensa_model.dart';

final class DespensaModelTestFactory {
  static DespensaModel create({
    String? id,
    String? name,
    String? inviteCode,
    List<String>? adminIds,
    List<String>? memberIds,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    final now = DateTime(2024, 6, 1, 12);

    return DespensaModel(
      id: id ?? 'despensaId',
      name: name ?? 'Despensa de teste',
      inviteCode: inviteCode ?? 'INV123',
      adminIds: adminIds ?? ['admin1'],
      memberIds: memberIds ?? ['admin1', 'membro2'],
      createdAt: createdAt ?? now,
      updatedAt: updatedAt ?? now,
    );
  }
}
