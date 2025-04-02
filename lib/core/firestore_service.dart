import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreConstants {
  static const String despensasCollection = 'despensas';
  static const String usuariosSubcollection = 'usuarios';

  static const String usersCollection = 'users';
  static const String despensasSubcollection = 'despensas';

  static const String roleField = 'role';
  static const String memberRole = 'member';
}

class FirestoreService {
  final FirebaseFirestore _db;

  FirestoreService({FirebaseFirestore? firebaseFirestore})
      : _db = firebaseFirestore ?? FirebaseFirestore.instance;

  // Adicionar um usuário a uma despensa
  Future<void> addUserToDespensa(String userId, String despensaId) async {
    try {
      await _db.runTransaction((transaction) async {
        final despensaUsuariosRef = _db
            .collection(FirestoreConstants.despensasCollection)
            .doc(despensaId)
            .collection(FirestoreConstants.usuariosSubcollection)
            .doc(userId);

        final userDespensasRef = _db
            .collection(FirestoreConstants.usersCollection)
            .doc(userId)
            .collection(FirestoreConstants.despensasSubcollection)
            .doc(despensaId);

        transaction.set(
          despensaUsuariosRef,
          {FirestoreConstants.roleField: FirestoreConstants.memberRole},
        );

        transaction.set(userDespensasRef, {});
      });
    } on FirebaseException catch (e) {
      throw FirestoreException(
          'Erro ao adicionar usuário à despensa: ${e.message}');
    }
  }

  // Remover usuário de uma despensa
  Future<void> removeUserFromDespensa(String userId, String despensaId) async {
    try {
      await _db.runTransaction((transaction) async {
        final despensaUsuariosRef = _db
            .collection(FirestoreConstants.despensasCollection)
            .doc(despensaId)
            .collection(FirestoreConstants.usuariosSubcollection)
            .doc(userId);

        final userDespensasRef = _db
            .collection(FirestoreConstants.usersCollection)
            .doc(userId)
            .collection(FirestoreConstants.despensasSubcollection)
            .doc(despensaId);

        transaction.delete(despensaUsuariosRef);

        transaction.delete(userDespensasRef);
      });
    } on FirebaseException catch (e) {
      throw FirestoreException(
          'Erro ao remover usuário da despensa: ${e.message}');
    }
  }
}

class FirestoreException implements Exception {
  final String message;
  FirestoreException(this.message);

  @override
  String toString() => message;
}
