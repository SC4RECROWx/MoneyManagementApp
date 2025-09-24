
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_management_app/services/budget_service.dart';
import 'package:money_management_app/views/budget/blocs/budget_event.dart';
import 'package:money_management_app/views/budget/blocs/budget_state.dart';

class BudgetBloc extends Bloc<BudgetEvent, BudgetState> {
  BudgetBloc() : super(BudgetInitial()) {
    on<CreateBudgetEvent>(_onCreateBudget);
    on<UpdateBudgetEvent>(_onUpdateBudget);
    on<LoadBudgetEvent>(_onLoadBudget);
    on<DeleteBudgetEvent>(_onDeleteBudget);
  }

  void _onCreateBudget(
    CreateBudgetEvent event,
    Emitter<BudgetState> emit,
  ) async {
    // Handle create budget logic
    emit(BudgetLoading());
    try {
      // Simulate a network call or database operation
      BudgetService.addBudget(event.budget);
      emit(BudgetSuccess(message: 'Budget created successfully'));
      add(LoadBudgetEvent()); // Optionally reload budgets
    } catch (e) {
      emit(BudgetError(message: 'Failed to create budget: ${e.toString()}'));
      return;
    }
  }

  void _onLoadBudget(LoadBudgetEvent event, Emitter<BudgetState> emit) async {
    emit(BudgetLoading());
    try {
      // Simulate fetching budgets from a database or API
      final budgets = await BudgetService.fetchBudgetsWithKategoris();
      emit(BudgetLoaded(budgets: budgets));
    } catch (e) {
      emit(BudgetError(message: 'Failed to load budgets: ${e.toString()}'));
    }
  }

  void _onUpdateBudget(
    UpdateBudgetEvent event,
    Emitter<BudgetState> emit,
  ) async {
    // Handle update budget logic
    emit(BudgetLoading());
    try {
      // Simulate a network call or database operation
      await BudgetService.updateBudget(event.budget);
      emit(BudgetSuccess(message: 'Budget updated successfully'));
      add(LoadBudgetEvent()); // Optionally reload budgets
    } catch (e) {
      emit(BudgetError(message: 'Failed to update budget: ${e.toString()}'));
    }
  }

  void _onDeleteBudget(
    DeleteBudgetEvent event,
    Emitter<BudgetState> emit,
  ) async {
    emit(BudgetLoading());
    try {
      await BudgetService.deleteBudget(event.budget);
      emit(BudgetSuccess(message: 'Budget deleted successfully'));
      add(LoadBudgetEvent()); // Optionally reload budgets
    } catch (e) {
      emit(BudgetError(message: 'Failed to delete budget: ${e.toString()}'));
    }
  }
}
