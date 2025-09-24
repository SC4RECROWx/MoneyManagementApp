import 'package:money_management_app/models/kategori_model.dart';

abstract class KategoriEvent {}

class LoadKategoriEvent extends KategoriEvent {
  final String budgetId;
  LoadKategoriEvent({required this.budgetId});
}

class CreateKategoriEvent extends KategoriEvent {
  final KategoriModel kategori;
  CreateKategoriEvent({required this.kategori});
}

class UpdateKategoriEvent extends KategoriEvent {
  final KategoriModel kategori;
  UpdateKategoriEvent({required this.kategori});
}

class DeleteKategoriEvent extends KategoriEvent {
  final KategoriModel kategori;
  DeleteKategoriEvent({required this.kategori});
}

class FilteredKategoriEvent extends KategoriEvent {
  final String? budgetId;
  final double? from;
  final double? to;

  FilteredKategoriEvent({this.budgetId, this.from, this.to});
}
