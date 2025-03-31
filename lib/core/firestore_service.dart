import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db;

  FirestoreService({FirebaseFirestore? firebaseFirestore})
      : _db = firebaseFirestore ?? FirebaseFirestore.instance;

  // Adicionar um usuário a uma despensa
  Future<void> addUserToDespensa(String userId, String despensaId) async {
    await _db
        .collection('despensas')
        .doc(despensaId)
        .collection('usuarios')
        .doc(userId)
        .set({
      'role': 'member', // ou 'admin', dependendo do tipo de acesso
    });
    await _db
        .collection('users')
        .doc(userId)
        .collection('despensas')
        .doc(despensaId)
        .set({});
  }

  // Remover usuário de uma despensa
  Future<void> removeUserFromDespensa(String userId, String despensaId) async {
    await _db
        .collection('despensas')
        .doc(despensaId)
        .collection('usuarios')
        .doc(userId)
        .delete();
    await _db
        .collection('users')
        .doc(userId)
        .collection('despensas')
        .doc(despensaId)
        .delete();
  }
}
