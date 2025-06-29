import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([
  FirebaseFirestore,
  Transaction,
  CollectionReference<Map<String, dynamic>>,
  DocumentReference<Map<String, dynamic>>,
  DocumentSnapshot<Map<String, dynamic>>,
])
void main() {}
