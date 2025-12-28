import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:repondo/core/exceptions/firestore_exception_mapper.dart';
import 'package:repondo/core/exports.dart';
import 'package:repondo/core/firebase/retry_reader.dart';
import 'package:repondo/core/log/exports.dart';
import 'package:repondo/features/despensa/data/constants/despensa_firestore_keys.dart';
import 'package:repondo/features/item/data/exceptions/firebase_item_exception_mapper.dart';
import 'package:repondo/features/item/data/exports.dart';
import 'package:repondo/features/item/domain/exports.dart';

class FirebaseItemRepository implements ItemRepository {
  final FirebaseFirestore _firestore;
  final AppLogger _logger;

  FirebaseItemRepository(
      {FirebaseFirestore? firestore, required AppLogger logger})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _logger = logger;

  @override
  Future<Result<Item, ItemException>> createItem(
      {required CreateItemParams params, required String despensaId}) {
    return runCatching(() async {
      _logger.info('Iniciando criação do item com os parâmetros: $params');

      final itemModel = ItemModel.fromCreateParams(params);
      final now = FieldValue.serverTimestamp();
      final itemMap = {
        ...itemModel.toMap(),
        ItemFirestoreKeys.lastPurchasedAt: now,
      };

      final itemRef = await _firestore
          .collection(DespensaFirestoreKeys.collectionName)
          .doc(despensaId)
          .collection(ItemFirestoreKeys.collectionName)
          .add(itemMap);
      _logger.info('Item criado com sucesso: ${itemRef.id}');

      final resultRetry =
          await fetchWithRetry(docRef: itemRef, logger: _logger);
      final data = resultRetry.fold(
        (error) {
          _logger.warning('Dados do item não encontrados após criação.');
          throw ItemFetchAfterCreateException;
        },
        (data) => data,
      );

      final savedItemModel = ItemModel.fromMap(data, itemRef.id);
      _logger.info('Item salvo com sucesso: ${savedItemModel.id}');

      return savedItemModel.toEntity();
    }, (error) {
      _logger.error('Erro ao criar item', error, StackTrace.current);

      return switch (error) {
        ItemException itemException => itemException,
        FirestoreMapperException firestoreMapperException =>
          ItemUnknownException(
            code: firestoreMapperException.code,
          ),
        FirebaseException firebaseException => fromFirebaseItemExceptionMapper(
            fromFirestoreExceptionMapper(firebaseException),
          ),
        _ => ItemUnknownException(code: 'unknown'),
      };
    });
  }

  @override
  Future<Result<List<Item>, ItemException>> fetchDespensaItems({
    required String despensaId,
  }) {
    return runCatching(() async {
      _logger.info('Buscando itens da despensa: $despensaId');

      final querySnapshot = await _firestore
          .collection(DespensaFirestoreKeys.collectionName)
          .doc(despensaId)
          .collection(ItemFirestoreKeys.collectionName)
          .get();

      final items = querySnapshot.docs.map((doc) {
        final model = ItemModel.fromMap(doc.data(), doc.id);
        return model.toEntity();
      }).toList();

      _logger.info(
        'Itens carregados com sucesso. Total: ${items.length}',
      );

      return items;
    }, (error) {
      _logger.error(
        'Erro ao buscar itens da despensa: $despensaId',
        error,
        StackTrace.current,
      );

      return switch (error) {
        ItemException itemException => itemException,
        FirestoreMapperException firestoreMapperException =>
          ItemUnknownException(
            code: firestoreMapperException.code,
          ),
        FirebaseException firebaseException => fromFirebaseItemExceptionMapper(
            fromFirestoreExceptionMapper(firebaseException),
          ),
        _ => ItemUnknownException(code: 'unknown'),
      };
    });
  }
}
