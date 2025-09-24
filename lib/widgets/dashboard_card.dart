import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class DashboardCard extends StatelessWidget {
  final double income;
  final double expense;
  final double saving;

  const DashboardCard({
    super.key,
    required this.income,
    required this.expense,
    required this.saving,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              "Keuangan Bulan Ini",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 18),
            SizedBox(
              height: 140,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: income,
                      color: Colors.green,
                      title: 'Income',
                      radius: 40,
                      titleStyle: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                    PieChartSectionData(
                      value: expense,
                      color: Colors.red,
                      title: 'Expense',
                      radius: 40,
                      titleStyle: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                    PieChartSectionData(
                      value: saving,
                      color: Colors.blue,
                      title: 'Saving',
                      radius: 40,
                      titleStyle: const TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ],
                  sectionsSpace: 2,
                  centerSpaceRadius: 30,
                ),
              ),
            ),
            const SizedBox(height: 18),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _LegendDot(color: Colors.green, label: "Income"),
                _LegendDot(color: Colors.red, label: "Expense"),
                _LegendDot(color: Colors.blue, label: "Saving"),
              ],
            ),
            const SizedBox(height: 18),
            SizedBox(
              height: 80,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  barTouchData: BarTouchData(enabled: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(),
                    rightTitles: AxisTitles(),
                    topTitles: AxisTitles(),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          switch (value.toInt()) {
                            case 0:
                              return const Text('Income');
                            case 1:
                              return const Text('Expense');
                            case 2:
                              return const Text('Saving');
                            default:
                              return const SizedBox();
                          }
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: [
                    BarChartGroupData(x: 0, barRods: [
                      BarChartRodData(toY: income, color: Colors.green, width: 18),
                    ]),
                    BarChartGroupData(x: 1, barRods: [
                      BarChartRodData(toY: expense, color: Colors.red, width: 18),
                    ]),
                    BarChartGroupData(x: 2, barRods: [
                      BarChartRodData(toY: saving, color: Colors.blue, width: 18),
                    ]),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 13)),
      ],
    );
  }
}