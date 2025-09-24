import 'package:money_management_app/models/budget_model.dart';
import 'package:money_management_app/models/kategori_model.dart';

abstract class KategoriState {}

class KategoriInitial extends KategoriState {}

class KategoriLoading extends KategoriState {}

class KategoriLoaded extends KategoriState {
  final List<KategoriModel> kategoris;
  final List<BudgetModel> budgets; // Added budgets list
  final Map<String?, dynamic>? filtersApply; // Optional filter text for UI

  KategoriLoaded(this.kategoris, this.budgets, {this.filtersApply});
}

class KategoriError extends KategoriState {
  final String message;

  KategoriError(this.message);
}

class KategoriSuccess extends KategoriState {
  final String message;

  KategoriSuccess(this.message);
}
