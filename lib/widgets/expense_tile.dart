import 'package:flutter/material.dart';

class ExpenseTile extends StatelessWidget {
  const ExpenseTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(title: Text('Expense'));
  }
}
