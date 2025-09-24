import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_management_app/views/expense/blocs/expense_bloc.dart';
import 'package:money_management_app/views/expense/blocs/expense_event.dart';
import 'package:money_management_app/views/expense/blocs/expense_state.dart';
import 'package:money_management_app/views/shared/bottom_nav.dart';
import 'package:money_management_app/views/expense/helper/expense_helper.dart';

class ExpensePage extends StatelessWidget {
  const ExpensePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNav(currentIndex: 2),
      appBar: AppBar(title: const Text('Kelola Pengeluaran')),
      body: BlocListener<ExpenseBloc, ExpenseState>(
        listener: (context, state) {
          if (state is ExpenseSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                duration: const Duration(seconds: 2),
              ),
            );
          } else if (state is ExpenseError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                duration: const Duration(seconds: 2),
              ),
            );
          }
        },
        child: BlocBuilder<ExpenseBloc, ExpenseState>(
          builder: (context, state) {
            if (state is ExpenseInitial) {
              context.read<ExpenseBloc>().add(LoadExpenseEvent());
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ExpenseLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ExpenseLoaded) {
              final expenses = state.expenses;
              final budgets = state.budgets;
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<ExpenseBloc>().add(LoadExpenseEvent());
                },
                child: Column(
                  children: [
                    buildHeaderCard(expenses, budgets, context),
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
                                  'Daftar Pengeluaran',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.filter_list),
                                  tooltip: 'Filter Pengeluaran',
                                  color: Colors.teal,
                                  iconSize: 28,
                                  onPressed: () => showFilterDialog(
                                    context,
                                    state.filtersApply,
                                    budgets,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: buildFilterChips(
                                    state.filtersApply,
                                    budgets,
                                    context,
                                    state,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Jumlah: ${expenses.length}',
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
                              child: buildExpenseList(
                                expenses,
                                budgets,
                                context,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
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
