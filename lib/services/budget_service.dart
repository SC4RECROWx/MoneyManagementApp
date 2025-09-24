import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:money_management_app/models/budget_model.dart';
import 'package:money_management_app/models/expense_model.dart';
import 'package:money_management_app/models/kategori_model.dart';
import 'package:money_management_app/services/auth_service.dart';
import 'package:money_management_app/services/expense_service.dart';
import 'package:money_management_app/services/kategori_services.dart';
import 'dart:developer'; // Add for logging

class BudgetService {
  static Future<List<BudgetModel>> fetchBudgetsWithKategoris() async {
    log("Fetching budgets with kategoris...");
    try {
      final userId = await AuthService().getCurrentUserId();
      log("User ID for budgets: $userId");
      final budgets = await FirebaseFirestore.instance
          .collection('budgets')
          .where('userId', isEqualTo: userId)
          .get();

      log("Found ${budgets.docs.length} budgets for user $userId");
      var budgetsWithKategoris = await Future.wait(
        budgets.docs.map((doc) async {
          log("Fetching kategoris for budget: ${doc.id}");
          List<KategoriModel> kategoris =
              await KategoriService.fetchKategorisByBudget(doc.id);
          log("Found ${kategoris.length} kategoris for budget: ${doc.id}");
          return BudgetModel.fromMap({
            ...doc.data(),
            'id': doc.id,
            'kategoris': kategoris.map((kategori) => kategori.toMap()).toList(),
          });
        }).toList(),
      );
      log("Returning budgets with kategoris");
      return budgetsWithKategoris;
    } catch (e) {
      log("Failed to load budgets with kategoris: $e", level: 1000);
      throw Exception('Failed to load budgets: ${e.toString()}');
    }
  }

  static Future<List<BudgetModel>> fetchAll() async {
    log("Fetching all budgets...");
    try {
      final userId = await AuthService().getCurrentUserId();
      log("User ID for budgets: $userId");
      final budgets = await FirebaseFirestore.instance
          .collection('budgets')
          .where('userId', isEqualTo: userId)
          .get();

      log("Found ${budgets.docs.length} budgets for user $userId");
      return budgets.docs.map((doc) {
        return BudgetModel.fromMap({...doc.data(), 'id': doc.id});
      }).toList();
    } catch (e) {
      log("Failed to load budgets: $e", level: 1000);
      throw Exception('Failed to load budgets: ${e.toString()}');
    }
  }

  // Budget state management
  static Future<void> addBudget(BudgetModel budget) async {
    log("Adding new budget: ${budget.toMap()}");
    try {
      List<KategoriModel> kategoris = budget.kategoris ?? [];
      final budgetRef = await FirebaseFirestore.instance
          .collection('budgets')
          .add(budget.copyWith(kategoris: () => []).toMap());

      log("Budget added with ID: ${budgetRef.id}");
      await budgetRef.update({'id': budgetRef.id});

      for (KategoriModel kategori in kategoris) {
        log("Adding kategori to budget: ${kategori.toMap()}");
        await KategoriService.addKategori(
          kategori.copyWith(budgetId: budgetRef.id),
        );
      }
      log("All kategoris added for budget: ${budgetRef.id}");
    } catch (e) {
      log("Failed to add budget: $e", level: 1000);
      throw Exception('Failed to add budget: ${e.toString()}');
    }
  }

  static Future<void> updateBudget(BudgetModel budget) async {
    log("Updating budget: ${budget.id}");
    try {
      for (KategoriModel kategori in budget.kategoris ?? []) {
        log("Updating kategori: ${kategori.id}");
        await KategoriService.updateKategori(kategori);
      }

      final dbref = FirebaseFirestore.instance
          .collection('budgets')
          .doc(budget.id);

      await dbref.update(budget.copyWith(kategoris: () => []).toMap());
      log("Budget updated: ${budget.id}");
    } catch (e) {
      log("Failed to update budget: $e", level: 1000);
      throw Exception('Failed to update budget: ${e.toString()}');
    }
  }

  static Future<void> deleteBudget(BudgetModel budget) async {
    log("Deleting budget: ${budget.id}");
    try {
      for (KategoriModel kategori in budget.kategoris ?? []) {
        log("Deleting kategori: ${kategori.id}");
        await FirebaseFirestore.instance
            .collection('kategoris')
            .doc(kategori.id)
            .delete();
      }

      final List<ExpenseModel> expenses = await ExpenseService.fetchByBudget(
        budget.id,
      );
      log("Deleting ${expenses.length} expenses for budget: ${budget.id}");
      await Future.wait(
        expenses.map((expense) async {
          log("Deleting expense: ${expense.id}");
          await ExpenseService.deleteExpense(expense);
        }),
      );

      await FirebaseFirestore.instance
          .collection('budgets')
          .doc(budget.id)
          .delete();
      log("Budget deleted: ${budget.id}");
    } catch (e) {
      log("Failed to delete budget: $e", level: 1000);
      throw Exception('Failed to delete budget: ${e.toString()}');
    }
  }
}
