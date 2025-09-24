import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:money_management_app/core/utils/utils.dart';
import 'package:money_management_app/models/expense_model.dart';
import 'package:money_management_app/models/income_model.dart';

class PemasukanPengeluaranBarChart extends StatelessWidget {
  final String viewType;
  final int selectedMonth;
  final int selectedYear;
  final List<IncomeModel> incomeData;
  final List<ExpenseModel> expenseData;

  final List<String> _months = Utils.getListMonthNames();

  PemasukanPengeluaranBarChart({
    super.key,
    required this.viewType,
    required this.selectedMonth,
    required this.selectedYear,
    required this.incomeData,
    required this.expenseData,
  });

  @override
  Widget build(BuildContext context) {
    return _buildChart();
  }

  Widget _buildChart() {
    // Global variables
    late Map<int, double> incomeMaps;
    late Map<int, double> expenseMaps;
    late List<BarChartGroupData> barGroups;

    if (viewType == 'Tahunan') {
      incomeMaps = _groupByMonth<IncomeModel>(
        incomeData,
        (i) => i.createAt,
        (i) => i.amount,
      );
      expenseMaps = _groupByMonth<ExpenseModel>(
        expenseData,
        (e) => e.createAt,
        (e) => e.amount,
      );

      barGroups = List.generate(
        12,
        (month) => BarChartGroupData(
          x: month,
          barRods: [
            BarChartRodData(
              toY: incomeMaps[month] ?? 0,
              color: Colors.green,
              width: 10,
            ),
            BarChartRodData(
              toY: expenseMaps[month] ?? 0,
              color: Colors.red,
              width: 10,
            ),
          ],
        ),
      );
    } else {
      incomeMaps = _groupByDay<IncomeModel>(
        incomeData,
        (i) => i.createAt,
        (i) => i.amount,
      );
      expenseMaps = _groupByDay<ExpenseModel>(
        expenseData,
        (e) => e.createAt,
        (e) => e.amount,
      );

      // Get the number of days in the selected month and year
      final daysInMonth = DateTime(selectedYear, selectedMonth + 1, 0).day;

      barGroups = List.generate(
        daysInMonth,
        (day) => BarChartGroupData(
          x: day + 1,
          barRods: [
            BarChartRodData(
              toY: incomeMaps[day + 1] ?? 0,
              color: Colors.green,
              width: 10,
            ),
            BarChartRodData(
              toY: expenseMaps[day + 1] ?? 0,
              color: Colors.red,
              width: 10,
            ),
          ],
        ),
      );
    }

    return BarChart(
      BarChartData(
        maxY: _getMaxY(incomeMaps, expenseMaps) == 0
            ? 1
            : _getMaxY(incomeMaps, expenseMaps),
        minY: 0,
        alignment: BarChartAlignment.spaceAround,
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            direction: TooltipDirection.top,
            getTooltipColor: (color) => Colors.teal,
            tooltipBorder: const BorderSide(color: Colors.teal, width: 1),
            maxContentWidth: 200,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final isIncome = rod.color == Colors.green;
              final amount = rod.toY;
              final label = isIncome ? 'Pemasukan' : 'Pengeluaran';
              return BarTooltipItem(
                '$label: ${Utils.toIDR(amount)}\n',
                const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                  color: Colors.white,
                ),
                children: [
                  TextSpan(
                    text: '${_months[group.x]} $selectedYear',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              );
            },
          ),
          enabled: true,
        ),
        titlesData: FlTitlesData(
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, _) => Text(
                Utils.currencySuffix(value),
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: viewType == 'Tahunan'
                  ? 1
                  : (barGroups.length > 15
                        ? 5
                        : 1), // tampilkan tiap 5 hari jika banyak
              getTitlesWidget: (value, _) {
                if (viewType == 'Tahunan') {
                  return Transform.rotate(
                    alignment: Alignment.topCenter,
                    origin: Offset(10, 50),
                    angle: -45 * 3.14 / 180,
                    child: Text(
                      Utils.getMonthName(value.toInt()),
                      style: const TextStyle(fontSize: 12),
                    ),
                  );
                } else {
                  // Untuk bulanan, tampilkan hanya interval tertentu
                  int interval = barGroups.length > 15 ? 5 : 1;
                  if (value % interval == 0 &&
                      value > 0 &&
                      value <= barGroups.length) {
                    return Text(
                      value.toInt().toString(),
                      style: const TextStyle(fontSize: 12),
                    );
                  }
                  return const SizedBox.shrink();
                }
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        gridData: FlGridData(show: true),
        barGroups: barGroups,
      ),
    );
  }

  Map<int, double> _groupByDay<T>(
    List<T> data,
    DateTime Function(T) getDate,
    double Function(T) getAmount,
  ) {
    final Map<int, double> grouped = {};
    for (var item in data) {
      final date = getDate(item);
      if (date.month == selectedMonth + 1 && date.year == selectedYear) {
        // selectedMonth is 0-based
        final day = date.day;
        grouped[day] = (grouped[day] ?? 0) + getAmount(item);
      }
    }
    return grouped;
  }

  Map<int, double> _groupByMonth<T>(
    List<T> data,
    DateTime Function(T) getDate,
    double Function(T) getAmount,
  ) {
    final Map<int, double> grouped = {};
    for (var item in data) {
      final date = getDate(item);
      if (date.year == selectedYear) {
        final month = date.month - 1; // 0-based index for months
        grouped[month] = (grouped[month] ?? 0) + getAmount(item);
      }
    }
    return grouped;
  }

  double _getMaxY(Map<int, double> incomeMaps, Map<int, double> expenseMaps) {
    final maxIncome = incomeMaps.values.fold<double>(
      0,
      (a, b) => a > b ? a : b,
    );
    final maxExpense = expenseMaps.values.fold<double>(
      0,
      (a, b) => a > b ? a : b,
    );
    return (maxIncome > maxExpense ? maxIncome : maxExpense) * 1.2;
  }
}
