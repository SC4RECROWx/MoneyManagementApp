import 'dart:developer';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:money_management_app/core/utils/utils.dart';
import 'package:money_management_app/models/budget_model.dart';
import 'package:money_management_app/models/expense_model.dart';
import 'package:money_management_app/models/kategori_model.dart';
import 'package:money_management_app/services/budget_service.dart';
import 'package:money_management_app/services/expense_service.dart';
import 'package:money_management_app/services/kategori_services.dart';
import 'package:money_management_app/widgets/custom_card.dart';

class DistribusiData {
  final String kategori;
  final double total;
  final Color color;

  DistribusiData({
    required this.kategori,
    required this.total,
    required this.color,
  });
}

class DistribusiChart extends StatefulWidget {
  const DistribusiChart({super.key});

  @override
  State<DistribusiChart> createState() => _DistribusiChartState();
}

class _DistribusiChartState extends State<DistribusiChart> {
  List<DistribusiData> data = [];
  bool isLoading = true;
  bool isError = false;

  Future<void> _fetch() async {
    try {
      // Fetch budget and expense in parallel
      final results = await Future.wait([
        BudgetService.fetchAll(),
        ExpenseService.fetchAll(),
      ]);
      final budgetList = results[0] as List<BudgetModel>;
      final expenseList = results[1] as List<ExpenseModel>;

      // Build budget lookup and color map
      final budgetMap = {for (var b in budgetList) b.id!: b};
      final Map<String, double> totalPerBudget = {};
      final Map<String, Color> colorPerBudget = {};

      // Aggregate totals per budget
      for (var expense in expenseList) {
        final budget = budgetMap[expense.budgetId];
        if (budget == null) continue;
        totalPerBudget.update(
          budget.name,
          (v) => v + expense.amount,
          ifAbsent: () => expense.amount,
        );
        colorPerBudget.putIfAbsent(
          budget.name,
          () => budget.color ?? Colors.grey,
        );
      }

      // Prepare chart data
      final distribusiDataList = totalPerBudget.entries
          .map(
            (entry) => DistribusiData(
              kategori: entry.key,
              total: entry.value,
              color: colorPerBudget[entry.key] ?? Colors.grey,
            ),
          )
          .toList();

      if (data.isEmpty) {
        setState(() {
          isError = true;
          isLoading = false;
        });
      }
      setState(() {
        data = distribusiDataList;
        isLoading = false;
        isError = false;
      });
    } catch (e) {
      log('Error fetching distribusi data: $e');
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

  Widget _buildPieChart() {
    return PieChart(
      PieChartData(
        sections: data.map((kategori) {
          final total = data.fold<num>(
            0,
            (sum, item) => sum + (item.total as num),
          );
          final percent = ((kategori.total as num) / total * 100)
              .toStringAsFixed(1);
          return PieChartSectionData(
            value: ((kategori.total) as num).toDouble(),
            color: kategori.color,
            title: '$percent%',
            titleStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            radius: 50,
          );
        }).toList(),
        sectionsSpace: 2,
        centerSpaceRadius: 40,
      ),
    );
  }

  Widget _buildDetailChart() {
    return Center(
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.center,
        spacing: 16,
        children: data.map((data) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: data.color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Tooltip(
                preferBelow: false,
                message: '${data.kategori} (${Utils.toIDR(data.total)})',
                child: Text(
                  data.kategori,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      header: const Text(
        'Distribusi Pengeluaran Budget',
        textAlign: TextAlign.center,
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5),
          SizedBox(
            height: 180,
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : isError
                ? const Center(child: Text('Gagal memuat data'))
                : data.isEmpty
                ? const Center(child: Text('Tidak ada data'))
                : _buildPieChart(),
          ),
          const SizedBox(height: 18),
          _buildDetailChart(),
        ],
      ),
    );
  }
}
