import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_management_app/core/utils/utils.dart';
import 'package:money_management_app/models/budget_model.dart';
import 'package:money_management_app/models/kategori_model.dart';
import 'package:money_management_app/views/kategori/bloc/kategori_bloc.dart';
import 'package:money_management_app/views/kategori/bloc/kategori_event.dart';
import 'package:money_management_app/views/kategori/bloc/kategori_state.dart';
import 'package:money_management_app/views/kategori/views/kategori_form.dart';
import 'package:money_management_app/views/shared/alert/warning_alert.dart';
import 'package:money_management_app/views/shared/buttons/save_button.dart';
import 'package:money_management_app/views/shared/list_card.dart';

class KategoriPage extends StatefulWidget {
  final BudgetModel budget;
  const KategoriPage({super.key, required this.budget});

  @override
  State<KategoriPage> createState() => _KategoriPageState();
}

class _KategoriPageState extends State<KategoriPage> {
  void _addKategori(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => BlocProvider.value(
        value: context.read<KategoriBloc>(),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: KategoriForm(
            kategori: KategoriModel(
              userId: '',
              budgetId: widget.budget.id!,
              kategori: '',
              planned: 0,
            ),
            onSubmit: (kategori) {
              if (context.read<KategoriBloc>().isKategoriMoreThanBudgetAmount(
                isEditing: false,
                kategori: kategori,
                budget: widget.budget,
              )) {
                WarningAlert.show(
                  context: context,
                  title: "Perhatian",
                  message: "Kategori melebihi jumlah budget",
                  actions: [
                    Expanded(
                      child: SaveButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        label: 'Tutup',
                      ),
                    ),
                  ],
                );
                return;
              }
              context.read<KategoriBloc>().add(
                CreateKategoriEvent(kategori: kategori),
              );
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }

  void _editKategori(BuildContext context, KategoriModel kategori) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => BlocProvider.value(
        value: context.read<KategoriBloc>(),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: KategoriForm(
            kategori: kategori,
            onSubmit: (updatedKategori) {
              if (context.read<KategoriBloc>().isKategoriMoreThanBudgetAmount(
                isEditing: true,
                kategori: updatedKategori,
                budget: widget.budget,
              )) {
                WarningAlert.show(
                  context: context,
                  title: "Perhatian",
                  message: "Kategori melebihi jumlah budget",
                  actions: [
                    Expanded(
                      child: SaveButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        label: 'Tutup',
                      ),
                    ),
                  ],
                );
                return;
              }
              context.read<KategoriBloc>().add(
                UpdateKategoriEvent(kategori: updatedKategori),
              );
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard(
    List<KategoriModel> kategoris,
    List<BudgetModel> budgets,
    BuildContext context,
  ) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.teal,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.budget.name,
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            Utils.toIDR(widget.budget.amount),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 28,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              const Spacer(),
              Container(
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
                ),
                child: IconButton(
                  icon: const Icon(Icons.add, color: Colors.white),
                  onPressed: () {
                    if (context
                        .read<KategoriBloc>()
                        .isKategoriEqualToBudgetAmount(widget.budget)) {
                      WarningAlert.show(
                        context: context,
                        title: "Perhatian",
                        message: "Budget sudah dialokasikan secara menyeluruh",
                        actions: [
                          Expanded(
                            child: SaveButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              label: 'Tutup',
                            ),
                          ),
                        ],
                      );
                      return;
                    }
                    _addKategori(context);
                  },
                  tooltip: 'Tambah Kategori',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips(
    Map<String?, dynamic>? filtersApply,
    List<BudgetModel> budgets,
    BuildContext context,
    KategoriLoaded state,
  ) {
    if (filtersApply == null || filtersApply.isEmpty) {
      return Text(
        'Total ${Utils.toIDR(state.kategoris.fold<double>(0, (prev, kategori) => prev + kategori.planned))}',
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: filtersApply.entries.map((entry) {
          String label;
          if (entry.key == 'budgetId') {
            final budget = budgets.firstWhere(
              (b) => b.id == entry.value,
              orElse: () => BudgetModel(
                userId: '',
                id: '',
                name: 'Semua',
                amount: 0,
                startAt: DateTime.now(),
                endAt: DateTime.now(),
              ),
            );
            label = 'Budget: ${budget.name}';
          } else if (entry.key == 'from') {
            label =
                'Min: ${Utils.toIDR((entry.value is num) ? entry.value.toDouble() : 0)}';
          } else if (entry.key == 'to') {
            label =
                'Max: ${Utils.toIDR((entry.value is num) ? entry.value.toDouble() : 0)}';
          } else {
            label = '${entry.key}: ${entry.value ?? 'Semua'}';
          }

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Chip(
              label: Text(label),
              backgroundColor: Colors.blue.shade100,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              onDeleted: () {
                context.read<KategoriBloc>().add(
                  FilteredKategoriEvent(
                    budgetId: entry.key == 'budgetId'
                        ? null
                        : (filtersApply['budgetId'] as String?),
                    from: entry.key == 'from'
                        ? null
                        : (filtersApply['from'] is num
                              ? (filtersApply['from'] as num).toDouble()
                              : null),
                    to: entry.key == 'to'
                        ? null
                        : (filtersApply['to'] is num
                              ? (filtersApply['to'] as num).toDouble()
                              : null),
                  ),
                );
              },
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildKategoriList(
    List<KategoriModel> kategoris,
    List<BudgetModel> budgets,
    BuildContext context,
  ) {
    if (kategoris.isEmpty) {
      return Center(
        child: Text(
          'Tidak ada data kategori',
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }
    return ListView.builder(
      itemCount: kategoris.length,
      itemBuilder: (context, index) {
        final item = kategoris[index];
        return ListCard(
          onTap: () => _editKategori(context, item),
          title: item.kategori,
          subtitle: Utils.formatDateIndonesian(item.createdAt as DateTime),
          amount: item.planned,
          type: 'expense',
          color: item.color ?? Colors.blue,
          action: IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              context.read<KategoriBloc>().add(
                DeleteKategoriEvent(kategori: item),
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kelola Kategori'),
        automaticallyImplyLeading: false,
      ),
      body: BlocListener<KategoriBloc, KategoriState>(
        listener: (context, state) {
          if (state is KategoriSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                duration: const Duration(seconds: 2),
              ),
            );
          } else if (state is KategoriError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                duration: const Duration(seconds: 2000),
              ),
            );
          }
        },
        child: BlocBuilder<KategoriBloc, KategoriState>(
          builder: (context, state) {
            if (state is KategoriInitial) {
              context.read<KategoriBloc>().add(
                LoadKategoriEvent(budgetId: widget.budget.id!),
              );
              return const Center(child: CircularProgressIndicator());
            }
            if (state is KategoriLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is KategoriLoaded) {
              final kategoris = state.kategoris;
              final budgets = state.budgets;
              return Column(
                children: [
                  _buildHeaderCard(kategoris, budgets, context),
                  const SizedBox(height: 24),
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Dana Teralokasi',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: _buildFilterChips(
                                  state.filtersApply,
                                  budgets,
                                  context,
                                  state,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Jumlah: ${kategoris.length}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          const Divider(thickness: 0.5, color: Colors.grey),
                          const SizedBox(height: 12),
                          Expanded(
                            child: _buildKategoriList(
                              kategoris,
                              budgets,
                              context,
                            ),
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: SaveButton(
                                  onPressed: () {
                                    if (!context
                                        .read<KategoriBloc>()
                                        .isKategoriEqualToBudgetAmount(
                                          widget.budget,
                                        )) {
                                      WarningAlert.show(
                                        context: context,
                                        title: "Perhatian",
                                        message:
                                            "Budget belum dialokasikan secara menyeluruh",
                                        actions: [
                                          Expanded(
                                            child: SaveButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                                _addKategori(context);
                                              },
                                              label: 'Tambah Kategori',
                                            ),
                                          ),
                                        ],
                                      );
                                    } else {
                                      Navigator.pushNamed(context, '/budget');
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
            return Center(
              child: Text(
                'Tidak ada data pemasukan',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          },
        ),
      ),
    );
  }
}
