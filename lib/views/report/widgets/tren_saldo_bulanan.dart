import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:money_management_app/core/utils/utils.dart';
import 'package:money_management_app/services/expense_service.dart';
import 'package:money_management_app/services/income_service.dart';
import 'package:money_management_app/views/report/components/legend_item.dart';
import 'package:money_management_app/widgets/custom_card.dart';

class TrenSaldoBulananData {
  double saldo;
  DateTime bulan;

  TrenSaldoBulananData({required this.saldo, required this.bulan});
}

class TrenSaldoBulanan extends StatefulWidget {
  const TrenSaldoBulanan({super.key});

  @override
  State<TrenSaldoBulanan> createState() => _TrenSaldoBulananState();
}

class _TrenSaldoBulananState extends State<TrenSaldoBulanan> {
  List<TrenSaldoBulananData> monthlyData = [];
  bool isLoading = true;

  Future<void> _fetchData() async {
    final year = DateTime.now().year;
    final month = DateTime.now().month;
    final incomes = await IncomeService.fetchByYear(year);
    final expenses = await ExpenseService.fetchByYear(year);

    // Preprocess incomes and expenses by month for O(1) lookup
    final incomeByMonth = List<double>.filled(month, 0);
    final expenseByMonth = List<double>.filled(month, 0);

    for (final income in incomes) {
      final m = income.createAt.month - 1;
      if (income.createAt.year == year && m >= 0 && m < month) {
        incomeByMonth[m] += income.amount;
      }
    }
    for (final expense in expenses) {
      final m = expense.createAt.month - 1;
      if (expense.createAt.year == year && m >= 0 && m < month) {
        expenseByMonth[m] += expense.amount;
      }
    }

    monthlyData = List.generate(month, (i) {
      final month = DateTime(year, i + 1);
      final saldo = incomeByMonth[i] - expenseByMonth[i];
      return TrenSaldoBulananData(saldo: saldo, bulan: month);
    });

    if (!mounted) return;

    setState(() {
      monthlyData = monthlyData;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  double get maxSaldo {
    return monthlyData.isNotEmpty
        ? monthlyData.map((e) => e.saldo).reduce((a, b) => a > b ? a : b) * 1.2
        : 0;
  }

  double get minSaldo {
    return monthlyData.isNotEmpty
        ? monthlyData.map((e) => e.saldo).reduce((a, b) => a < b ? a : b) * 1.2
        : 0;
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      header: const Text('Tren Saldo Bulanan'),
      content: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 70, top: 20),
            // padding: const EdgeInsets.all(0),
            child: SizedBox(
              height: 200,
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : LineChart(
                      LineChartData(
                        maxY: maxSaldo,
                        minY: minSaldo,
                        maxX: DateTime.now().month.toDouble(),
                        minX: 0,
                        gridData: FlGridData(show: true),
                        lineTouchData: LineTouchData(
                          touchTooltipData: LineTouchTooltipData(
                            getTooltipColor: (touchedSpot) => Colors.teal,
                            getTooltipItems: (touchedSpots) =>
                                touchedSpots.map((touchedSpot) {
                                  final month = Utils.getMonthName(
                                    touchedSpot.x.toInt() + 1,
                                  );
                                  final saldo = touchedSpot.y;
                                  return LineTooltipItem(
                                    '$month\n${Utils.toIDR(saldo)}',
                                    TextStyle(color: Colors.white),
                                  );
                                }).toList(),
                          ),
                        ),
                        titlesData: FlTitlesData(
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 40,
                              getTitlesWidget: (value, _) => Text(
                                Utils.currencySuffix(value),
                                style: TextStyle(fontSize: 8),
                              ),
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              interval: 1,
                              getTitlesWidget: (value, meta) {
                                return Transform.rotate(
                                  alignment: Alignment.topCenter,
                                  origin: Offset(20, 50),
                                  angle: -45 * 3.14 / 180,
                                  child: Text(
                                    Utils.getMonthName(value.toInt()),
                                    style: TextStyle(fontSize: 12),
                                  ),
                                );
                              },
                            ),
                          ),
                          rightTitles: AxisTitles(),
                          topTitles: AxisTitles(),
                        ),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: List.generate(monthlyData.length, (i) {
                              final saldo = monthlyData[i].saldo;
                              return FlSpot(i.toDouble(), saldo.toDouble());
                            }),
                            isCurved: true,
                            color: Colors.blue,
                            barWidth: 4,
                            dotData: FlDotData(show: false),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
          // SizedBox(height: 20),
          LegendItem(color: Colors.blue, label: 'Saldo'),
        ],
      ),
    );
  }
}
