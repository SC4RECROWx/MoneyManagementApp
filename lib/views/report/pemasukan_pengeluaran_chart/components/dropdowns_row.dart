import 'package:flutter/material.dart';

class DropdownsRow extends StatelessWidget {
  final String viewType;
  final int selectedMonth;
  final int selectedYear;
  final List<String> viewTypes;
  final List<String> months;
  final ValueChanged<String?> onViewTypeChanged;
  final ValueChanged<int?> onMonthChanged;
  final ValueChanged<int?> onYearChanged;

  const DropdownsRow({
    super.key,
    required this.viewType,
    required this.selectedMonth,
    required this.selectedYear,
    required this.viewTypes,
    required this.months,
    required this.onViewTypeChanged,
    required this.onMonthChanged,
    required this.onYearChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DropdownButton<String>(
          value: viewType,
          items: viewTypes
              .map((type) => DropdownMenuItem(value: type, child: Text(type)))
              .toList(),
          onChanged: onViewTypeChanged,
        ),
        if (viewType == 'Bulanan') ...[
          const SizedBox(width: 16),
          DropdownButton<int>(
            value: selectedMonth,
            items: List.generate(
              12,
              (i) => DropdownMenuItem(value: i, child: Text(months[i])),
            ),
            onChanged: onMonthChanged,
          ),
        ],
        SizedBox(width: 16),
        DropdownButton<int>(
          value: selectedYear,
          items: List.generate(
            10,
            (i) => DropdownMenuItem(
              value: DateTime.now().year - i,
              child: Text((DateTime.now().year - i).toString()),
            ),
          ),
          onChanged: onYearChanged,
        ),
      ],
    );
  }
}
