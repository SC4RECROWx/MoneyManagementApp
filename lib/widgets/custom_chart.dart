import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CustomChart extends StatelessWidget {
  const CustomChart({super.key});

  @override
  Widget build(BuildContext context) {
    return PieChart(
      PieChartData(
        centerSpaceRadius: 40,
        sections: [
          PieChartSectionData(
            value: 40,
            color: Colors.orange,
            title: 'Makanan',
            radius: 50,
            titleStyle: const TextStyle(fontSize: 12),
          ),
          PieChartSectionData(
            value: 30,
            color: Colors.blue,
            title: 'Transport',
            radius: 50,
            titleStyle: const TextStyle(fontSize: 12),
          ),
          PieChartSectionData(
            value: 30,
            color: Colors.purple,
            title: 'Lainnya',
            radius: 50,
            titleStyle: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
