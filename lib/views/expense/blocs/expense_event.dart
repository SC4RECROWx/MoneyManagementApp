import 'package:money_management_app/models/expense_model.dart';

abstract class ExpenseEvent {}

class LoadExpenseEvent extends ExpenseEvent {}

class CreateExpenseEvent extends ExpenseEvent {
  final ExpenseModel expense;
  CreateExpenseEvent({required this.expense});
}

class UpdateExpenseEvent extends ExpenseEvent {
  final ExpenseModel expense;
  UpdateExpenseEvent({required this.expense});
}

class DeleteExpenseEvent extends ExpenseEvent {
  final ExpenseModel expense;
  DeleteExpenseEvent({required this.expense});
}

class FilteredExpenseEvent extends ExpenseEvent {
  final String? budgetId;
  final double? from;
  final double? to;

  FilteredExpenseEvent({this.budgetId, this.from, this.to});
}
