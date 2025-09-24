import 'package:flutter/material.dart';

class SummaryInfo extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const SummaryInfo({super.key, 
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              child: const Icon(
                Icons.attach_money,
                color: Colors.white,
                size: 18,
              ),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [Text(label), const SizedBox(height: 4), Text(value)],
            ),
          ],
        ),
      ),
    );
  }
}
