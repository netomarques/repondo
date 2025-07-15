import 'package:cloud_firestore/cloud_firestore.dart';

/// Tenta buscar os dados de um [DocumentReference] até obter um resultado não nulo e não vazio.
/// Retorna `null` se falhar após [maxRetries].
Future<Map<String, dynamic>?> fetchWithRetry({
  required DocumentReference<Map<String, dynamic>> docRef,
  int maxRetries = 5,
  Duration delayBetweenRetries = const Duration(milliseconds: 100),
}) async {
  for (int attempt = 0; attempt < maxRetries; attempt++) {
    final snapshot = await docRef.get();
    final data = snapshot.data();
    if (data != null && data.isNotEmpty) return data;

    if (attempt < maxRetries - 1) {
      await Future.delayed(delayBetweenRetries);
    }
  }
  return null;
}
