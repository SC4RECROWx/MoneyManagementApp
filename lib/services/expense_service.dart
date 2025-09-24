import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:money_management_app/models/expense_model.dart';
import 'package:money_management_app/services/auth_service.dart';
import 'dart:developer';

class ExpenseService {
  static Future<List<ExpenseModel>> fetchAll() async {
    log("Fetching all expenses...");
    try {
      final userId = await AuthService().getCurrentUserId();
      log("User ID for expenses: $userId");
      final snapshot = await FirebaseFirestore.instance
          .collection('expenses')
          .where('userId', isEqualTo: userId)
          .get();

      log("Found ${snapshot.docs.length} expenses for user $userId");
      return snapshot.docs
          .map((doc) => ExpenseModel.fromMap({...doc.data(), 'id': doc.id}))
          .toList()
        ..sort((a, b) => b.createAt.compareTo(a.createAt));
    } catch (e) {
      log("Failed to load expenses: $e", level: 1000);
      throw Exception('Failed to load expenses: ${e.toString()}');
    }
  }

  static Future<void> addExpense(ExpenseModel expense) async {
    log("Adding new expense: ${expense.toMap()}");
    try {
      final expenseRef = await FirebaseFirestore.instance
          .collection('expenses')
          .add(expense.toMap());
      log("Expense added with ID: ${expenseRef.id}");
      await expenseRef.update({'id': expenseRef.id});
    } catch (e) {
      log("Failed to add expense: $e", level: 1000);
      throw Exception('Failed to add expense: ${e.toString()}');
    }
  }

  static Future<void> updateExpense(ExpenseModel expense) async {
    log("Updating expense: ${expense.id}");
    try {
      await FirebaseFirestore.instance
          .collection('expenses')
          .doc(expense.id)
          .update(expense.toMap());
      log("Expense updated: ${expense.id}");
    } catch (e) {
      log("Failed to update expense: $e", level: 1000);
      throw Exception('Failed to update expense: ${e.toString()}');
    }
  }

  static Future<void> deleteExpense(ExpenseModel expense) async {
    log("Deleting expense: ${expense.id}");
    try {
      await FirebaseFirestore.instance
          .collection('expenses')
          .doc(expense.id)
          .delete();
      log("Expense deleted: ${expense.id}");
    } catch (e) {
      log("Failed to delete expense: $e", level: 1000);
      throw Exception('Failed to delete expense: ${e.toString()}');
    }
  }

  static Future<List<ExpenseModel>> fetchByYear(int year) async {
    try {
      final start = DateTime(year, 1, 1);
      final end = DateTime(year + 1, 1, 1);
      final snapshot = await ExpenseService.fetchAll();

      return snapshot.where((expense) {
        final createAt = expense.createAt;
        return createAt.isAfter(start) && createAt.isBefore(end);
      }).toList()..sort((a, b) => b.createAt.compareTo(a.createAt));
    } catch (e) {
      throw Exception(
        'Failed to load expenses for year $year: ${e.toString()}',
      );
    }
  }

  static fetchByBudget(String? id) async {
    if (id == null) return Future.value([]);

    final String userId = await AuthService().getCurrentUserId();

    return FirebaseFirestore.instance
        .collection('expenses')
        .where('budgetId', isEqualTo: id)
        .where('userId', isEqualTo: userId)
        .get()
        .then((snapshot) {
          return snapshot.docs
              .map((doc) => ExpenseModel.fromMap(doc.data()))
              .toList()
            ..sort((a, b) => b.createAt.compareTo(a.createAt));
        });
  }
}
