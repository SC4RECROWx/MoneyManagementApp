import 'package:money_management_app/models/budget_model.dart';

abstract class BudgetState {}

class BudgetInitial extends BudgetState {}

class BudgetLoading extends BudgetState {}

class BudgetLoaded extends BudgetState {
  final List<BudgetModel> budgets;

  BudgetLoaded({required this.budgets});
}

class BudgetSuccess extends BudgetState {
  final String message;

  BudgetSuccess({required this.message});
}

class BudgetError extends BudgetState {
  final String message;

  BudgetError({required this.message});
}
