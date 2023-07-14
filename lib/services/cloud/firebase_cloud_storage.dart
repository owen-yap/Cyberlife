import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cyberlife/services/cloud/cloud_result.dart';
import 'package:cyberlife/services/cloud/cloud_storage_constants.dart';
import 'package:cyberlife/services/cloud/cloud_storage_exceptions.dart';

class FirebaseCloudStorage {
  final results = FirebaseFirestore.instance.collection('results');

  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;

  Future<CloudResult> createNewResult({required String ownerUserId}) async {
    final doc = await results.add({
      ownerUserIdFieldName: ownerUserId,
      textFieldName: '',
    });
    final fetchedResult = await doc.get();

    return CloudResult(
      documentId: fetchedResult.id,
      ownerUserId: ownerUserId,
      text: '',
    );
  }

  Future<Iterable<CloudResult>> getResults(
      {required String ownerUserId}) async {
    try {
      return await results
          .where(
            ownerUserIdFieldName,
            isEqualTo: ownerUserId,
          )
          .get()
          .then(
            (value) => value.docs.map(
              (doc) {
                return CloudResult(
                  documentId: doc.id,
                  ownerUserId: doc.data()[ownerUserIdFieldName] as String,
                  text: doc.data()[textFieldName] as String,
                );
              },
            ),
          );
    } catch (e) {
      throw CouldNotGetAllResultsException();
    }
  }

  Future<void> updateResult({
    required String documentId,
    required String text,
  }) async {
    try {
      await results.doc(documentId).update({textFieldName: text});
    } catch (e) {
      throw CouldNotUpdateResultException();
    }
  }

  Future<void> deleteResult({required String documentId}) async {
    try {
      await results.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteResultException();
    }
  }
}
