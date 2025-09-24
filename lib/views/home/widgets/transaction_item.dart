import 'package:flutter/material.dart';
import 'package:money_management_app/core/utils/utils.dart';

class TransactionItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final double amount;
  final String type;
  EdgeInsetsGeometry margin;
  EdgeInsetsGeometry padding;
  Radius borderRadius;

  TransactionItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.type,
    this.margin = const EdgeInsets.only(bottom: 32),
    this.padding = const EdgeInsets.all(18),
    this.borderRadius = const Radius.circular(18),
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: margin,
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(borderRadius.x),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(
                context,
                type == 'income' ? '/income' : '/expense',
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF1B233A),
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.teal,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      Utils.toIDR(amount),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: type == 'income' ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),
        ),

        Positioned(
          right: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: type == 'income' ? Colors.green : Colors.red,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(borderRadius.x),
                topRight: Radius.circular(borderRadius.x),
              ),
            ),
            child: Text(
              type == 'income' ? 'Pemasukan' : 'Pengeluaran',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
