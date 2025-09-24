import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_management_app/services/budget_service.dart';
import 'package:money_management_app/services/expense_service.dart';
import 'package:money_management_app/views/expense/blocs/expense_event.dart';
import 'package:money_management_app/views/expense/blocs/expense_state.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  ExpenseBloc() : super(ExpenseInitial()) {
    on<LoadExpenseEvent>(_onLoadExpense);
    on<CreateExpenseEvent>(_onCreateExpense);
    on<UpdateExpenseEvent>(_onUpdateExpense);
    on<DeleteExpenseEvent>(_onDeleteExpense);
    on<FilteredExpenseEvent>(_onFilteredExpense);
  }

  Future<void> _onLoadExpense(
    LoadExpenseEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(ExpenseLoading());
    try {
      final expenses = await ExpenseService.fetchAll();
      final budgets = await BudgetService.fetchBudgetsWithKategoris();
      emit(ExpenseLoaded(expenses, budgets));
    } catch (e) {
      emit(ExpenseError('Gagal memuat data: $e'));
    }
  }

  Future<void> _onCreateExpense(
    CreateExpenseEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(ExpenseLoading());
    try {
      await ExpenseService.addExpense(event.expense);
      emit(ExpenseSuccess('Berhasil Menambahkan Data'));
      add(LoadExpenseEvent());
    } catch (e) {
      emit(ExpenseError('Failed to create Expense: $e'));
    }
  }

  Future<void> _onUpdateExpense(
    UpdateExpenseEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(ExpenseLoading());
    try {
      await ExpenseService.updateExpense(event.expense);
      emit(ExpenseSuccess('Berhasil Mengupdate Data'));
      add(LoadExpenseEvent());
    } catch (e) {
      emit(ExpenseError('Failed to update Expense: $e'));
    }
  }

  Future<void> _onDeleteExpense(
    DeleteExpenseEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(ExpenseLoading());
    try {
      await ExpenseService.deleteExpense(event.expense);
      emit(ExpenseSuccess('Berhasil Menghapus Data'));
      add(LoadExpenseEvent());
    } catch (e) {
      emit(ExpenseError('Failed to delete Expense: $e'));
    }
  }

  Future<void> _onFilteredExpense(
    FilteredExpenseEvent event,
    Emitter<ExpenseState> emit,
  ) async {
    emit(ExpenseLoading());
    try {
      final expenses = await ExpenseService.fetchAll();
      final budgets = await BudgetService.fetchBudgetsWithKategoris();

      final filteredExpenses = expenses.where((expense) {
        final matchesBudget =
            event.budgetId == null || expense.budgetId == event.budgetId;
        final matchesFrom = event.from == null || expense.amount >= event.from!;
        final matchesTo = event.to == null || expense.amount <= event.to!;
        return matchesBudget && matchesFrom && matchesTo;
      }).toList();

      final filtersApply = <String, dynamic>{
        if (event.budgetId != null) 'budgetId': event.budgetId,
        if (event.from != null) 'from': event.from,
        if (event.to != null) 'to': event.to,
      };

      emit(ExpenseSuccess('Berhasil Memfilter Data'));
      emit(
        ExpenseLoaded(filteredExpenses, budgets, filtersApply: filtersApply),
      );
    } catch (e) {
      emit(ExpenseError('Failed to filter Expenses: $e'));
    }
  }
}
