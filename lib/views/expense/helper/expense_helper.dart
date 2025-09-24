import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_management_app/models/budget_model.dart';
import 'package:money_management_app/models/expense_model.dart';
import 'package:money_management_app/core/utils/utils.dart';
import 'package:money_management_app/models/filter_model.dart';
import 'package:money_management_app/views/expense/blocs/expense_bloc.dart';
import 'package:money_management_app/views/expense/blocs/expense_event.dart';
import 'package:money_management_app/views/expense/blocs/expense_state.dart';
import 'package:money_management_app/views/expense/views/expense_form.dart';
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
      value: context.read<ExpenseBloc>(),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: FilterForm(
          filter: FilterModel(
            budgetId: filterApply?["budgetId"],
            from: filterApply?["from"],
            to: filterApply?["to"],
          ),
          budgets: budgets,
          onFilter: (filter) {
            context.read<ExpenseBloc>().add(
              FilteredExpenseEvent(
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

void addExpense(BuildContext context, List<BudgetModel> budgets) {
  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => BlocProvider.value(
      value: context.read<ExpenseBloc>(),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ExpenseForm(
          budgets: budgets,
          onSubmit: (expense) {
            context.read<ExpenseBloc>().add(
              CreateExpenseEvent(expense: expense),
            );
            Navigator.pop(context);
          },
        ),
      ),
    ),
  );
}

void editExpense(
  BuildContext context,
  ExpenseModel expense,
  List<BudgetModel> budgets,
) {
  showModalBottomSheet(
    isScrollControlled: true,
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (_) => BlocProvider.value(
      value: context.read<ExpenseBloc>(),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ExpenseForm(
          expense: expense,
          budgets: budgets,
          onSubmit: (updatedExpense) {
            context.read<ExpenseBloc>().add(
              UpdateExpenseEvent(expense: updatedExpense),
            );
            Navigator.pop(context);
          },
        ),
      ),
    ),
  );
}

Widget buildHeaderCard(
  List<ExpenseModel> expenses,
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
          "Total Pengeluaran",
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
        const SizedBox(height: 8),
        Text(
          Utils.toIDR(
            expenses.fold<double>(0, (prev, expense) => prev + expense.amount),
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
                onPressed: () => addExpense(context, budgets),
                tooltip: 'Tambah Pengeluaran',
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
  ExpenseLoaded state,
) {
  if (filtersApply == null || filtersApply.isEmpty) {
    return Text(
      'Total ${Utils.toIDR(state.expenses.fold<double>(0, (prev, expense) => prev + expense.amount))}',
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
            backgroundColor: Colors.teal.shade100,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            onDeleted: () {
              context.read<ExpenseBloc>().add(
                FilteredExpenseEvent(
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

Widget buildExpenseList(
  List<ExpenseModel> expenses,
  List<BudgetModel> budgets,
  BuildContext context,
) {
  if (expenses.isEmpty) {
    return Center(
      child: Text(
        'Tidak ada data pemasukan',
        style: const TextStyle(fontSize: 16, color: Colors.grey),
      ),
    );
  }
  return ListView.builder(
    itemCount: expenses.length,
    itemBuilder: (context, index) {
      final item = expenses[index];
      return ListCard(
        color: Colors.red,
        onTap: () => editExpense(context, item, budgets),
        title: item.source,
        subtitle: Utils.formatDateIndonesian(item.createAt),
        amount: item.amount,
        type: 'Pengeluaran',
      );
    },
  );
}
