import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_management_app/views/budget/blocs/budget_bloc.dart';
import 'package:money_management_app/views/budget/blocs/budget_state.dart';
import 'package:money_management_app/views/shared/bottom_nav.dart';
import 'package:money_management_app/views/budget/helpers/budget_helper.dart';

class BudgetPage extends StatelessWidget {
  const BudgetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNav(currentIndex: 3),
      appBar: AppBar(title: const Text('Kelola Budget')),
      body: BlocConsumer<BudgetBloc, BudgetState>(
        listener: (context, state) {
          if (state is BudgetSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Budget berhasil ditambahkan')),
            );
          }
          if (state is BudgetError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: buildBody,
      ),
    );
  }
}
