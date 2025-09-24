import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_management_app/services/budget_service.dart';
import 'package:money_management_app/services/income_service.dart';
import 'package:money_management_app/views/income/bloc/income_event.dart';
import 'package:money_management_app/views/income/bloc/income_state.dart';

class IncomeBloc extends Bloc<IncomeEvent, IncomeState> {
  IncomeBloc() : super(IncomeInitial()) {
    on<LoadIncomeEvent>(_onLoadIncome);
    on<CreateIncomeEvent>(_onCreateIncome);
    on<UpdateIncomeEvent>(_onUpdateIncome);
    on<DeleteIncomeEvent>(_onDeleteIncome);
    on<FilteredIncomeEvent>(_onFilteredIncome);
  }

  Future<void> _onLoadIncome(
    LoadIncomeEvent event,
    Emitter<IncomeState> emit,
  ) async {
    emit(IncomeLoading());
    try {
      final incomes = await IncomeService.fetchAll();
      final budgets = await BudgetService.fetchBudgetsWithKategoris();
      emit(IncomeLoaded(incomes, budgets));
    } catch (e) {
      emit(IncomeError('Gagal memuat data: $e'));
    }
  }

  Future<void> _onCreateIncome(
    CreateIncomeEvent event,
    Emitter<IncomeState> emit,
  ) async {
    emit(IncomeLoading());
    try {
      await IncomeService.addIncome(event.income);
      emit(IncomeSuccess('Berhasil Menambahkan Data'));
      add(LoadIncomeEvent());
    } catch (e) {
      emit(IncomeError('Failed to create Income: $e'));
    }
  }

  Future<void> _onUpdateIncome(
    UpdateIncomeEvent event,
    Emitter<IncomeState> emit,
  ) async {
    emit(IncomeLoading());
    try {
      await IncomeService.updateIncome(event.income);
      emit(IncomeSuccess('Berhasil Mengupdate Data'));
      add(LoadIncomeEvent());
    } catch (e) {
      emit(IncomeError('Failed to update Income: $e'));
    }
  }

  Future<void> _onDeleteIncome(
    DeleteIncomeEvent event,
    Emitter<IncomeState> emit,
  ) async {
    emit(IncomeLoading());
    try {
      await IncomeService.deleteIncome(event.income);
      emit(IncomeSuccess('Berhasil Menghapus Data'));
      add(LoadIncomeEvent());
    } catch (e) {
      emit(IncomeError('Failed to delete Income: $e'));
    }
  }

  Future<void> _onFilteredIncome(
    FilteredIncomeEvent event,
    Emitter<IncomeState> emit,
  ) async {
    emit(IncomeLoading());
    try {
      final incomes = await IncomeService.fetchAll();
      final budgets = await BudgetService.fetchBudgetsWithKategoris();

      final filteredIncomes = incomes.where((income) {
        // final matchesBudget =
        //     event.budgetId == null || income.budgetId == event.budgetId;
        final matchesFrom = event.from == null || income.amount >= event.from!;
        final matchesTo = event.to == null || income.amount <= event.to!;
        return
        // matchesBudget &&
        matchesFrom && matchesTo;
      }).toList();

      final filtersApply = <String, dynamic>{
        if (event.from != null) 'from': event.from,
        if (event.to != null) 'to': event.to,
      };

      emit(IncomeSuccess('Berhasil Memfilter Data'));
      emit(IncomeLoaded(filteredIncomes, budgets, filtersApply: filtersApply));
    } catch (e) {
      emit(IncomeError('Failed to filter Incomes: $e'));
    }
  }
}
