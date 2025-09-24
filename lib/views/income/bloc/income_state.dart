import 'package:money_management_app/models/budget_model.dart';
import 'package:money_management_app/models/income_model.dart';

abstract class IncomeState {}

class IncomeInitial extends IncomeState {}

class IncomeLoading extends IncomeState {}

class IncomeLoaded extends IncomeState {
  final List<IncomeModel> incomes;
  final List<BudgetModel> budgets; // Added budgets list
  final Map<String?, dynamic>? filtersApply; // Optional filter text for UI

  IncomeLoaded(this.incomes, this.budgets, {this.filtersApply});
}

class IncomeError extends IncomeState {
  final String message;

  IncomeError(this.message);
}

class IncomeSuccess extends IncomeState {
  final String message;

  IncomeSuccess(this.message);
}
