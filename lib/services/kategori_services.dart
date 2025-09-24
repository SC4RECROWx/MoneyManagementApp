import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:money_management_app/models/kategori_model.dart';
import 'package:money_management_app/services/auth_service.dart';

class KategoriService {
  static Future<List<KategoriModel>> fetchKategorisByBudget(
    String budgetId,
  ) async {
    log("Fetching kategoris for budget: $budgetId");
    try {
      final userId = await AuthService().getCurrentUserId();
      log("User ID for kategoris: $userId");
      final snapshot = await FirebaseFirestore.instance
          .collection('kategoris')
          .where('userId', isEqualTo: userId)
          .where('budgetId', isEqualTo: budgetId)
          .get();

      log("Found ${snapshot.docs.length} kategoris for budget $budgetId");
      return snapshot.docs
          .map((doc) => KategoriModel.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      log("Failed to load kategoris for budget $budgetId: $e", level: 1000);
      throw Exception('Failed to load kategoris: ${e.toString()}');
    }
  }

  static Future<List<KategoriModel>> fetchAll() async {
    log("Fetching all kategoris...");
    try {
      final userId = await AuthService().getCurrentUserId();
      log("User ID for kategoris: $userId");
      final snapshot = await FirebaseFirestore.instance
          .collection('kategoris')
          .where('userId', isEqualTo: userId)
          .get();

      log("Found ${snapshot.docs.length} kategoris for user $userId");
      return snapshot.docs
          .map((doc) => KategoriModel.fromMap({...doc.data(), 'id': doc.id}))
          .toList();
    } catch (e) {
      log("Failed to load all kategoris: $e", level: 1000);
      throw Exception('Failed to load all kategoris: ${e.toString()}');
    }
  }

  static Future<void> addKategori(KategoriModel kategori) async {
    log("Adding new kategori: ${kategori.toMap()}");
    try {
      final kategoriRef = await FirebaseFirestore.instance
          .collection('kategoris')
          .add(kategori.toMap());
      log("Kategori added with ID: ${kategoriRef.id}");
      await kategoriRef.update({'id': kategoriRef.id});
    } catch (e) {
      log("Failed to add kategori: $e", level: 1000);
      throw Exception('Failed to add kategori: ${e.toString()}');
    }
  }

  static Future<void> updateKategori(KategoriModel kategori) async {
    log('Updating kategori: ${kategori.toMap()}');
    try {
      if (kategori.id == null) {
        log('Kategori ID is null', level: 1000);
        await FirebaseFirestore.instance
            .collection('kategoris')
            .add(kategori.toMap());
        return;
      }

      await FirebaseFirestore.instance
          .collection('kategoris')
          .doc(kategori.id)
          .update(kategori.toMap());
      log('Kategori updated: ${kategori.id}');
    } catch (e) {
      log("Failed to update kategori: $e", level: 1000);
      throw Exception('Failed to update kategori: ${e.toString()}');
    }
  }

  static Future<void> deleteKategori(KategoriModel kategori) async {
    log("Deleting kategori: ${kategori.id}");
    try {
      await FirebaseFirestore.instance
          .collection('kategoris')
          .doc(kategori.id)
          .delete();
      log("Kategori deleted: ${kategori.id}");
    } catch (e) {
      log("Failed to delete kategori: $e", level: 1000);
      throw Exception('Failed to delete kategori: ${e.toString()}');
    }
  }
}
