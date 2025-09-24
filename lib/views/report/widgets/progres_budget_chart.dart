import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:money_management_app/core/utils/utils.dart';
import 'package:money_management_app/models/budget_model.dart';
import 'package:money_management_app/models/expense_model.dart';
import 'package:money_management_app/services/budget_service.dart';
import 'package:money_management_app/services/expense_service.dart';
import 'package:money_management_app/widgets/custom_card.dart';

class ProgressInfo {
  final BudgetModel budget;
  final double progress; // in percentage
  final double realization; // in double

  ProgressInfo({
    required this.budget,
    required this.progress,
    required this.realization,
  });
}

class ProgressBudgetChart extends StatefulWidget {
  const ProgressBudgetChart({super.key});

  @override
  State<ProgressBudgetChart> createState() => _ProgressBudgetChartState();
}

class _ProgressBudgetChartState extends State<ProgressBudgetChart> {
  List<ProgressInfo> data = [];
  bool isLoading = true;
  bool isError = false;

  Future<void> _fetch() async {
    try {
      final results = await Future.wait([
        BudgetService.fetchAll(),
        ExpenseService.fetchAll(),
      ]);
      final budgets = results[0] as List<BudgetModel>;
      final expenses = results[1] as List<ExpenseModel>;

      // Hitung progress tiap budget
      final List<ProgressInfo> progressList = budgets.map((budget) {
        final budgetAmount = budget.amount ?? 0.0;
        final totalExpense = expenses
            .where((e) => e.budgetId == budget.id)
            .fold(0.0, (sum, e) => sum + (e.amount ?? 0.0));
        final progress = budgetAmount == 0
            ? 0.0
            : (totalExpense / budgetAmount) * 100;
        return ProgressInfo(
          budget: budget,
          progress: progress,
          realization: totalExpense,
        );
      }).toList();

      setState(() {
        data = progressList;
        isLoading = false;
        isError = false;
      });
    } catch (e) {
      log('Error fetching progress budget data: $e');
      setState(() {
        isLoading = false;
        isError = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  Widget _buildProgressList() {
    return Column(
      children: data.map((info) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                info.budget.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              LinearProgressIndicator(
                value: (info.progress / 100).clamp(0.0, 1.0),
                backgroundColor: Colors.grey[300],
                color: info.budget.color,
                minHeight: 10,
              ),
              const SizedBox(height: 4),
              Text('${info.progress.toStringAsFixed(2)}%'),
              const SizedBox(height: 4),
              Text('Anggaran: ${Utils.toIDR(info.budget.amount)}'),
              const SizedBox(height: 4),
              Text('Terealisasi: ${Utils.toIDR(info.realization)}'),
              const SizedBox(height: 4),
              Text(
                'Keterangan: ${info.realization > (info.budget.amount ?? 0) ? 'Overbudget ( - ${Utils.toIDR(info.realization - (info.budget.amount ?? 0))})' : 'Underbudget (${Utils.toIDR((info.budget.amount ?? 0) - info.realization)} tersisa)'}',
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      header: const Text('Progress Budget Chart'),
      content: SizedBox(
        height: 300,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : isError
            ? const Center(child: Text('Gagal memuat data'))
            : data.isEmpty
            ? const Center(child: Text('Tidak ada budget'))
            : SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: _buildProgressList(),
              ),
      ),
    );
  }
}
