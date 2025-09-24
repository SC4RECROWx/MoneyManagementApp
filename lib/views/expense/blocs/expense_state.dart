import 'package:money_management_app/models/budget_model.dart';
import 'package:money_management_app/models/expense_model.dart';

abstract class ExpenseState {}

class ExpenseInitial extends ExpenseState {}

class ExpenseLoading extends ExpenseState {}

class ExpenseLoaded extends ExpenseState {
  final List<BudgetModel> budgets;
  final List<ExpenseModel> expenses;
  final Map<String?, dynamic>? filtersApply; // Optional filter text for UI

  ExpenseLoaded(this.expenses, this.budgets, {this.filtersApply});
}

class ExpenseError extends ExpenseState {
  final String message;

  ExpenseError(this.message);
}

class ExpenseSuccess extends ExpenseState {
  final String message;

  ExpenseSuccess(this.message);
}
