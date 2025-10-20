import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mockito/annotations.dart';
import 'package:repondo/features/despensa/domain/repositories/despensa_repository.dart';

@GenerateMocks([
  FirebaseFirestore,
  Transaction,
  CollectionReference<Map<String, dynamic>>,
  DocumentReference<Map<String, dynamic>>,
  DocumentSnapshot<Map<String, dynamic>>,
  DespensaRepository,
])
void main() {}
