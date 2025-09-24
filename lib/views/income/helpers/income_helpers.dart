import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_management_app/models/budget_model.dart';
import 'package:money_management_app/models/filter_model.dart';
import 'package:money_management_app/models/income_model.dart';
import 'package:money_management_app/core/utils/utils.dart';
import 'package:money_management_app/views/income/bloc/income_bloc.dart';
import 'package:money_management_app/views/income/bloc/income_event.dart';
import 'package:money_management_app/views/income/views/income_form.dart';
import 'package:money_management_app/views/shared/filter_form.dart';
import 'package:money_management_app/views/shared/list_card.dart';

void showFilterDialog(
  BuildContext context,
  Map<String?, dynamic>? filterApply,
  List<BudgetModel> budgets,
) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => BlocProvider.value(
      value: BlocProvider.of<IncomeBloc>(context),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: FilterForm(
          filter: FilterModel(
            budgetId: filterApply?["budgetId"],
            from: filterApply?["from"],
            to: filterApply?["to"],
          ),
          onFilter: (filter) {
            BlocProvider.of<IncomeBloc>(context).add(
              FilteredIncomeEvent(
                budgetId: filter.budgetId,
                from: filter.from,
                to: filter.to,
              ),
            );
            Navigator.pop(context);
          },
        ),
      ),
    ),
  );
}

void addIncome(BuildContext context, List<BudgetModel> budgets) {
  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => BlocProvider.value(
      value: BlocProvider.of<IncomeBloc>(context),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: IncomeForm(
          budgets: budgets,
          onSubmit: (income) {
            BlocProvider.of<IncomeBloc>(
              context,
            ).add(CreateIncomeEvent(income: income));
            Navigator.pop(context);
          },
        ),
      ),
    ),
  );
}

void editIncome(
  BuildContext context,
  IncomeModel income,
  List<BudgetModel> budgets,
) {
  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => BlocProvider.value(
      value: BlocProvider.of<IncomeBloc>(context),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: IncomeForm(
          income: income,
          budgets: budgets,
          onSubmit: (updatedIncome) {
            BlocProvider.of<IncomeBloc>(
              context,
            ).add(UpdateIncomeEvent(income: updatedIncome));
            Navigator.pop(context);
          },
        ),
      ),
    ),
  );
}

Widget buildHeaderCard(
  List<IncomeModel> incomes,
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
        const Text(
          "Total Pemasukan",
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
        const SizedBox(height: 8),
        Text(
          Utils.toIDR(
            incomes.fold<double>(
              0.0,
              (double prev, IncomeModel income) => prev + income.amount,
            ),
          ),
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
                onPressed: () => addIncome(context, budgets),
                tooltip: 'Tambah Pemasukan',
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget buildFilterChips(
  Map<String?, dynamic>? filtersApply,
  List<BudgetModel> budgets,
  BuildContext context,
  dynamic state,
) {
  if (filtersApply == null || filtersApply.isEmpty) {
    return Text(
      'Total ${Utils.toIDR(state.incomes.fold<double>(0.0, (double prev, IncomeModel income) => prev + income.amount))}',
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    );
  }

  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: filtersApply.entries.map((entry) {
        String label;
        if (entry.key == 'from') {
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
            backgroundColor: Colors.teal.shade100,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            onDeleted: () {
              BlocProvider.of<IncomeBloc>(context).add(
                FilteredIncomeEvent(
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

Widget buildIncomeList(
  List<IncomeModel> incomes,
  List<BudgetModel> budgets,
  BuildContext context,
) {
  if (incomes.isEmpty) {
    return Center(
      child: Text(
        'Tidak ada data pemasukan',
        style: const TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }
  return ListView.builder(
    itemCount: incomes.length,
    itemBuilder: (context, index) {
      final item = incomes[index];
      return ListCard(
        onTap: () => editIncome(context, item, budgets),
        title: item.source,
        subtitle: Utils.formatDateIndonesian(item.createAt),
        amount: item.amount,
        type: 'Pemasukan',
        color: Colors.green,
      );
    },
  );
}
