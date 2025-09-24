import 'package:money_management_app/models/transaction_model.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<TransactionModel> transactions;
  HomeLoaded({required this.transactions});
}

class HomeError extends HomeState {
  final String message;
  HomeError(this.message);
}
