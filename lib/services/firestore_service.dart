import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Add data to a collection
  Future<void> addData(String collection, Map<String, dynamic> data) async {
    await _db.collection(collection).add(data);
  }

  // Get all documents from a collection
  Stream<QuerySnapshot> getData(String collection) {
    return _db.collection(collection).snapshots();
  }

  // Update a document
  Future<void> updateData(
    String collection,
    String docId,
    Map<String, dynamic> data,
  ) async {
    await _db.collection(collection).doc(docId).update(data);
  }

  // Delete a document
  Future<void> deleteData(String collection, String docId) async {
    await _db.collection(collection).doc(docId).delete();
  }
}
