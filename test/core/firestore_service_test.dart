import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:repondo/core/firestore_service.dart';

import 'firestore_service_test.mocks.dart';

// Gerar os mocks antes de rodar os testes: flutter pub run build_runner build
@GenerateMocks([
  FirebaseFirestore,
  CollectionReference<Map<String, dynamic>>,
  DocumentReference<Map<String, dynamic>>
])
void main() {
  group('FirestoreService', () {
    late FirestoreService firestoreService;
    late MockFirebaseFirestore mockFirestore;
    late MockCollectionReference<Map<String, dynamic>> mockCollection;
    late MockDocumentReference<Map<String, dynamic>> mockDocument;

    setUp(() {
      mockFirestore = MockFirebaseFirestore();
      mockCollection = MockCollectionReference();
      mockDocument = MockDocumentReference();
      firestoreService = FirestoreService(firebaseFirestore: mockFirestore);

      // Configura os mocks para retornar as referências corretas
      when(mockFirestore.collection(any)).thenReturn(mockCollection);
      when(mockCollection.doc(any)).thenReturn(mockDocument);
      when(mockDocument.collection(any)).thenReturn(mockCollection);
      when(mockCollection.doc(any)).thenReturn(mockDocument);
    });

    test('Deve adicionar um usuário à despensa', () async {
      final userId = 'userId';
      final despensaId = 'despensaId';

      when(mockDocument.set(any)).thenAnswer((_) async {});

      await firestoreService.addUserToDespensa(userId, despensaId);

      verify(mockDocument.set(any)).called(greaterThanOrEqualTo(1));
    });

    test('Deve remover um usuário de uma despensa', () async {
      final userId = 'userId';
      final despensaId = 'despensaId';

      when(mockDocument.delete()).thenAnswer((_) async {});

      await firestoreService.removeUserFromDespensa(userId, despensaId);

      verify(mockDocument.delete()).called(greaterThanOrEqualTo(1));
    });
  });
}
