import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:repondo/core/constants/firebase_repository_error_messages.dart';
import 'package:repondo/core/exceptions/document_not_found_exception.dart';
import 'package:repondo/core/exceptions/empty_document_exception.dart';
import 'package:repondo/core/exceptions/firebase_repository_exception.dart';
import 'package:repondo/core/exceptions/firestore_exception_mapper.dart';
import 'package:repondo/core/exceptions/firestore_network_exception.dart';
import 'package:repondo/core/log/exports.dart';
import 'package:repondo/core/result/exports.dart';

/// Tenta buscar os dados de um [DocumentReference] até obter um resultado não nulo e não vazio.
Future<Result<Map<String, dynamic>, FirebaseRepositoryException>>
    fetchWithRetry({
  required DocumentReference<Map<String, dynamic>> docRef,
  required AppLogger logger,
  final maxRetries = 5,
  Duration delayBetweenRetries = const Duration(milliseconds: 100),
}) async {
  return runCatching(() async {
    final retries = maxRetries > 0 ? maxRetries : 5;

    for (int attempt = 0; attempt < retries; attempt++) {
      // Loga as últimas 2 tentativas ou todas se forem 2 ou menos
      if (retries <= 2 || attempt >= retries - 2) {
        logger.warning(
          'Tentativa ${attempt + 1}/$retries de buscar dados do documento ${docRef.id}',
        );
      }

      try {
        final snapshot = await docRef.get();

        if (!snapshot.exists) {
          logger.warning('Documento ${docRef.id} não existe.');
          throw DocumentNotFoundException();
        }

        final data = snapshot.data();
        if (data != null && data.isNotEmpty) return data;
      } on FirebaseException catch (e) {
        final errorMapped = fromFirestoreExceptionMapper(e);

        if (errorMapped is FirestoreNetworkException) {
          if (attempt == retries - 1) {
            logger.error(
              'Erro de rede ao buscar dados do documento ${docRef.id}',
            );
            throw errorMapped;
          }
        } else {
          throw errorMapped;
        }
      } on FirebaseRepositoryException {
        rethrow;
      }

      await Future.delayed(delayBetweenRetries);
    }

    logger.info('Documento ${docRef.id} vazio');
    throw EmptyDocumentException();
  }, (error) {
    logger.error(
      'Erro ao buscar dados do documento ${docRef.id}: $error',
    );

    if (error is FirebaseRepositoryException) return error;

    return FirebaseRepositoryException(
      FirebaseRepositoryErrorMessages.unknown,
    );
  });
}
