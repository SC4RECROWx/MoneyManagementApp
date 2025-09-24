import 'package:money_management_app/models/income_model.dart';

abstract class IncomeEvent {}

class LoadIncomeEvent extends IncomeEvent {}

class CreateIncomeEvent extends IncomeEvent {
  final IncomeModel income;
  CreateIncomeEvent({required this.income});
}

class UpdateIncomeEvent extends IncomeEvent {
  final IncomeModel income;
  UpdateIncomeEvent({required this.income});
}

class DeleteIncomeEvent extends IncomeEvent {
  final IncomeModel income;
  DeleteIncomeEvent({required this.income});
}

class FilteredIncomeEvent extends IncomeEvent {
  final String? budgetId;
  final double? from;
  final double? to;

  FilteredIncomeEvent({this.budgetId, this.from, this.to});
}
