import 'package:flutter/material.dart';
import '../../components/legend_item.dart';

class LegendRow extends StatelessWidget {
  const LegendRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        LegendItem(color: Colors.green, label: 'Pemasukan'),
        SizedBox(width: 18),
        LegendItem(color: Colors.red, label: 'Pengeluaran'),
      ],
    );
  }
}
