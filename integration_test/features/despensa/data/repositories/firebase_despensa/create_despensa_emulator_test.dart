import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:repondo/core/log/debug_logger.dart';
import 'package:repondo/core/result/exports.dart';
import 'package:repondo/features/despensa/data/constants/exports.dart';
import 'package:repondo/features/despensa/data/repositories/firebase_despensa_repository.dart';
import 'package:repondo/features/despensa/domain/entities/despensa.dart';
import 'package:repondo/features/despensa/domain/exceptions/despensa_exception.dart';
import 'package:repondo/features/despensa/domain/params/create_despensa_params.dart';
import 'package:repondo/firebase_options.dart';

import '../../../../../../test/features/despensa/mocks/despensa_test_factory.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late FirebaseDespensaRepository repository;
  late FirebaseFirestore firestore;

  const emulatorHost = '192.168.0.200';
  const firestorePort = 8082;
  const authPort = 8080;

  setUp(() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    firestore = FirebaseFirestore.instance;
    firestore.useFirestoreEmulator(emulatorHost, firestorePort);

    await FirebaseAuth.instance.useAuthEmulator(emulatorHost, authPort);

    repository = FirebaseDespensaRepository(
      firestore: firestore,
      logger: DebugLogger(),
    );
  });

  tearDownAll(() async {
    await FirebaseAuth.instance.signOut();
  });

  group('FirebaseDespensaRepository - createDespensa', () {
    test('Deve criar uma despensa com sucesso e retornar os dados salvos',
        () async {
      await FirebaseAuth.instance.signInAnonymously();

      final expectedDespensa = DespensaTestFactory.create();

      final params = CreateDespensaParams(
        name: expectedDespensa.name,
        adminIds: expectedDespensa.adminIds,
        memberIds: expectedDespensa.memberIds,
      );

      final result = await repository.createDespensa(params: params);

      expect(result, isA<Success<Despensa, DespensaException>>(),
          reason: 'Deve retornar sucesso ao criar despensa');
      expect(result.data, isA<Despensa>(),
          reason: 'Dados retornados devem ser do tipo Despensa');

      final data = result.data!;
      expect(data.id, isNotEmpty,
          reason: 'ID da despensa deve estar preenchido');

      final docSnapshot = await firestore
          .collection(DespensaFirestoreKeys.collectionName)
          .doc(data.id)
          .get();

      expect(docSnapshot.exists, isTrue,
          reason: 'Documento deve existir no Firestore');

      final dataSnapshot = docSnapshot.data()!;
      // Validar campos diretamente para evitar lógica duplicada
      expect(dataSnapshot['name'], equals(data.name));
      expect(dataSnapshot['adminIds'], equals(data.adminIds));
      expect(dataSnapshot['memberIds'], equals(data.memberIds));
      expect(dataSnapshot['createdAt'], isNotNull);
      expect(dataSnapshot['updatedAt'], isNotNull);
    });

    test('Deve falhar se usuário não estiver autenticado', () async {
      await FirebaseAuth.instance.signOut();

      final params = CreateDespensaParams(
        name: 'Sem Auth',
        adminIds: [],
        memberIds: [],
      );

      final result = await repository.createDespensa(params: params);

      expect(result, isA<Failure<Despensa, DespensaException>>());
      final error = result.error!;
      expect(error, isA<DespensaException>());
      expect(error.message, equals(DespensaErrorMessages.userNotAuthenticated));
    });
  });
}
