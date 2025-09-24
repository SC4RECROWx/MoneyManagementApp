import 'package:money_management_app/models/budget_model.dart';

abstract class BudgetEvent {}

class LoadBudgetEvent extends BudgetEvent {}

class CreateBudgetEvent extends BudgetEvent {
  final BudgetModel budget;
  CreateBudgetEvent({required this.budget});
}

class UpdateBudgetEvent extends BudgetEvent {
  final BudgetModel budget;

  UpdateBudgetEvent({required this.budget});
}

class DeleteBudgetEvent extends BudgetEvent {
  final BudgetModel budget;

  DeleteBudgetEvent({required this.budget});
}

class ClearBudgetEvent extends BudgetEvent {}
