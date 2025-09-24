import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:money_management_app/models/income_model.dart';
import 'package:money_management_app/services/auth_service.dart';
import 'dart:developer';

class IncomeService {
  static Future<List<IncomeModel>> fetchAll() async {
    log("Fetching all incomes...");
    try {
      final userId = await AuthService().getCurrentUserId();
      log("User ID for incomes: $userId");
      final snapshot = await FirebaseFirestore.instance
          .collection('incomes')
          .where('userId', isEqualTo: userId)
          .get();

      log("Found ${snapshot.docs.length} incomes for user $userId");
      return snapshot.docs
          .map((doc) => IncomeModel.fromMap({...doc.data(), 'id': doc.id}))
          .toList()
        ..sort((a, b) => b.createAt.compareTo(a.createAt));
    } catch (e) {
      log("Failed to load incomes: $e", level: 1000);
      throw Exception('Failed to load incomes: ${e.toString()}');
    }
  }

  static Future<void> addIncome(IncomeModel income) async {
    log("Adding new income: ${income.toMap()}");
    try {
      final docRef = await FirebaseFirestore.instance
          .collection('incomes')
          .add(income.toMap());
      log("Income added with ID: ${docRef.id}");
      await docRef.update({'id': docRef.id});
    } catch (e) {
      log("Failed to add income: $e", level: 1000);
      throw Exception('Failed to add income: ${e.toString()}');
    }
  }

  static Future<void> updateIncome(IncomeModel income) async {
    log("Updating income: ${income.id}");
    try {
      await FirebaseFirestore.instance
          .collection('incomes')
          .doc(income.id)
          .update(income.toMap());
      log("Income updated: ${income.id}");
    } catch (e) {
      log("Failed to update income: $e", level: 1000);
      throw Exception('Failed to update income: ${e.toString()}');
    }
  }

  static Future<void> deleteIncome(IncomeModel income) async {
    log("Deleting income: ${income.id}");
    try {
      await FirebaseFirestore.instance
          .collection('incomes')
          .doc(income.id)
          .delete();
      log("Income deleted: ${income.id}");
    } catch (e) {
      log("Failed to delete income: $e", level: 1000);
      throw Exception('Failed to delete income: ${e.toString()}');
    }
  }

  static Future<List<IncomeModel>> fetchByYear(int year) async {
    log("Fetching incomes for year: $year");
    try {
      final start = DateTime(year, 1, 1);
      final end = DateTime(year + 1, 1, 1);
      final snapshot = await IncomeService.fetchAll();

      final filtered = snapshot.where((income) {
        final createAt = income.createAt;
        return createAt.isAfter(start) && createAt.isBefore(end);
      }).toList()..sort((a, b) => b.createAt.compareTo(a.createAt));
      log("Found ${filtered.length} incomes for year $year");
      return filtered;
    } catch (e) {
      log("Failed to fetch incomes by year: $e", level: 1000);
      throw Exception('Failed to fetch incomes by year: ${e.toString()}');
    }
  }
}
