import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:repondo/core/exceptions/firestore_exception_mapper.dart';
import 'package:repondo/core/exports.dart';
import 'package:repondo/core/firebase/retry_reader.dart';
import 'package:repondo/core/log/exports.dart';
import 'package:repondo/features/item/data/exceptions/firebase_item_exception_mapper.dart';
import 'package:repondo/features/item/data/exports.dart';
import 'package:repondo/features/item/domain/exports.dart';

class FirebaseItemRepository implements ItemRepository {
  final FirebaseFirestore _firestore;
  final AppLogger _logger;

  FirebaseItemRepository(
      {required FirebaseFirestore? firestore, required AppLogger logger})
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
}
