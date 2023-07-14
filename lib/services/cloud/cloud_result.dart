import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyberlife/services/cloud/cloud_storage_constants.dart';

class CloudResult {
  final String documentId;
  final String ownerUserId;
  final String text;

  const CloudResult({
    required this.documentId,
    required this.ownerUserId,
    required this.text,
  });

  CloudResult.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        ownerUserId = snapshot.data()[ownerUserIdFieldName],
        text = snapshot.data()[textFieldName] as String;
}
