import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreService {
  FirestoreService._();
  static final instance = FirestoreService._();

  Future<void> setData({
    @required String path,
    @required Map<String, dynamic> data,
  }) async {
    final DocumentReference reference = FirebaseFirestore.instance.doc(path);
    print('set: $path: $data');
    await reference.set(data);
  }

  Future<void> deleteData({
    @required String path,
  }) async {
    final DocumentReference reference = FirebaseFirestore.instance.doc(path);
    print('delete: $path');
    await reference.delete();
  }

  Stream<T> documentStream<T>({
    @required String path,
    @required T Function(Map<String, dynamic> data, String documentId) builder,
  }) {
    final DocumentReference<Map<String, dynamic>> reference =
        FirebaseFirestore.instance.doc(path);
    final Stream<DocumentSnapshot<Map<String, dynamic>>> snapshots =
        reference.snapshots();
    return snapshots.map((snapshot) => builder(snapshot.data(), snapshot.id));
  }

  Stream<List<T>> collectionStream<T>({
    @required String path,
    @required T Function(Map<String, dynamic> data, String documentId) builder,
    Query<Map<String, dynamic>> Function(Query<Map<String, dynamic>> query)
        queryBuilder,
  }) {
    Query<Map<String, dynamic>> query =
        FirebaseFirestore.instance.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    final Stream<QuerySnapshot<Map<String, dynamic>>> snapshots =
        query.snapshots();
    return snapshots.map((snapshot) {
      return snapshot.docs
          .map((doc) => builder(doc.data(), doc.id))
          .where((value) => value != null)
          .toList();
      // WHERE because builder func may return null
    });
  }
}
