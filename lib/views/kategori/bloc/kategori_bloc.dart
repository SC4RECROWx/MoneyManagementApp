import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_management_app/models/budget_model.dart';
import 'package:money_management_app/models/kategori_model.dart';
import 'package:money_management_app/services/budget_service.dart';
import 'package:money_management_app/services/kategori_services.dart';
import 'package:money_management_app/views/kategori/bloc/kategori_event.dart';
import 'package:money_management_app/views/kategori/bloc/kategori_state.dart';

class KategoriBloc extends Bloc<KategoriEvent, KategoriState> {
  KategoriBloc() : super(KategoriInitial()) {
    on<LoadKategoriEvent>(_onLoadKategori);
    on<CreateKategoriEvent>(_onCreateKategori);
    on<UpdateKategoriEvent>(_onUpdateKategori);
    on<DeleteKategoriEvent>(_onDeleteKategori);
  }

  Future<void> _onLoadKategori(
    LoadKategoriEvent event,
    Emitter<KategoriState> emit,
  ) async {
    emit(KategoriLoading());
    try {
      final kategoris = await KategoriService.fetchKategorisByBudget(
        event.budgetId,
      );
      final budgets = await BudgetService.fetchBudgetsWithKategoris();

      emit(KategoriLoaded(kategoris, budgets));
    } catch (e) {
      emit(KategoriError('Gagal memuat data: $e'));
    }
  }

  Future<void> _onCreateKategori(
    CreateKategoriEvent event,
    Emitter<KategoriState> emit,
  ) async {
    emit(KategoriLoading());
    try {
      await KategoriService.addKategori(event.kategori);
      emit(KategoriSuccess('Berhasil Menambahkan Data'));
      add(LoadKategoriEvent(budgetId: event.kategori.budgetId));
    } catch (e) {
      emit(KategoriError('Failed to create Kategori: $e'));
    }
  }

  Future<void> _onUpdateKategori(
    UpdateKategoriEvent event,
    Emitter<KategoriState> emit,
  ) async {
    emit(KategoriLoading());
    try {
      await KategoriService.updateKategori(event.kategori);
      emit(KategoriSuccess('Berhasil Mengupdate Data'));
      add(LoadKategoriEvent(budgetId: event.kategori.budgetId));
    } catch (e) {
      emit(KategoriError('Failed to update Kategori: $e'));
    }
  }

  Future<void> _onDeleteKategori(
    DeleteKategoriEvent event,
    Emitter<KategoriState> emit,
  ) async {
    emit(KategoriLoading());
    try {
      await KategoriService.deleteKategori(event.kategori);
      emit(KategoriSuccess('Berhasil Menghapus Data'));
      add(LoadKategoriEvent(budgetId: event.kategori.budgetId));
    } catch (e) {
      emit(KategoriError('Failed to delete Kategori: $e'));
    }
  }

  double getTotalPlanned() {
    if (state is KategoriLoaded) {
      final loadedState = state as KategoriLoaded;
      return loadedState.kategoris.fold<double>(
        0,
        (previousValue, kategori) => previousValue + kategori.planned,
      );
    }
    return 0.0;
  }

  bool isKategoriEqualToBudgetAmount(BudgetModel budget) {
    return getTotalPlanned() == budget.amount;
  }

  bool isKategoriMoreThanBudgetAmount({
    required bool isEditing,
    required KategoriModel kategori,
    required BudgetModel budget,
  }) {
    return isEditing
        ? getTotalPlanned() > budget.amount
        : getTotalPlanned() + kategori.planned > budget.amount;
  }
}
