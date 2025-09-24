import 'package:bloc/bloc.dart';
import 'package:money_management_app/models/expense_model.dart';
import 'package:money_management_app/models/income_model.dart';
import 'package:money_management_app/models/transaction_model.dart';
import 'package:money_management_app/services/auth_service.dart';
import 'package:money_management_app/services/expense_service.dart';
import 'package:money_management_app/services/income_service.dart';
import 'package:money_management_app/views/home/bloc/home_event.dart';
import 'package:money_management_app/views/home/bloc/home_state.dart';

// Events

// Bloc
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<LoadHomeData>(_onLoadHomeData);
  }

  void _onLoadHomeData(LoadHomeData event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    try {
      List<IncomeModel> incomes = await IncomeService.fetchAll();
      List<ExpenseModel> expenses = await ExpenseService.fetchAll();

      List<TransactionModel> transactions = [
        ...incomes.map(
          (income) => TransactionModel(
            id: income.id,
            amount: income.amount,
            source: income.source,
            createAt: income.createAt,
            type: 'income',
          ),
        ),
        ...expenses.map(
          (expense) => TransactionModel(
            id: expense.id,
            amount: expense.amount,
            source: expense.source,
            createAt: expense.createAt,
            type: 'expense',
          ),
        ),
      ];
      transactions.sort((a, b) => b.createAt.compareTo(a.createAt));

      emit(HomeLoaded(transactions: transactions));
    } catch (e) {
      emit(HomeError("Failed to load home data: ${e.toString()}"));
      return;
    }
  }

  String get userName => AuthService().currentUser?.displayName ?? "Unknown";
  String get avatar =>
      AuthService().currentUser?.photoURL ?? "assets/avatars/avatar-1.png";
}
