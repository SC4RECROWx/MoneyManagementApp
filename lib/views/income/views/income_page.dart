import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_management_app/views/income/bloc/income_bloc.dart';
import 'package:money_management_app/views/income/bloc/income_event.dart';
import 'package:money_management_app/views/income/bloc/income_state.dart';
import 'package:money_management_app/views/shared/bottom_nav.dart';
import 'package:money_management_app/views/income/helpers/income_helpers.dart';

class IncomePage extends StatelessWidget {
  const IncomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNav(currentIndex: 1),
      appBar: AppBar(title: const Text('Kelola Pemasukan')),
      body: BlocListener<IncomeBloc, IncomeState>(
        listener: (context, state) {
          if (state is IncomeSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                duration: const Duration(seconds: 2),
              ),
            );
          } else if (state is IncomeError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                duration: const Duration(seconds: 2),
              ),
            );
          }
        },
        child: BlocBuilder<IncomeBloc, IncomeState>(
          builder: (context, state) {
            if (state is IncomeInitial) {
              context.read<IncomeBloc>().add(LoadIncomeEvent());
              return const Center(child: CircularProgressIndicator());
            }
            if (state is IncomeLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is IncomeLoaded) {
              final incomes = state.incomes;
              final budgets = state.budgets;
              return RefreshIndicator(
                onRefresh: () async {
                  context.read<IncomeBloc>().add(LoadIncomeEvent());
                },
                child: Column(
                  children: [
                    buildHeaderCard(incomes, budgets, context),
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
                                  'Daftar Pemasukan',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.filter_list),
                                  tooltip: 'Filter Pemasukan',
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
                                  'Jumlah: ${incomes.length}',
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
                              child: buildIncomeList(incomes, budgets, context),
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
