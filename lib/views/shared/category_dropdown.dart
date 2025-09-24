import 'package:flutter/material.dart';

class CategoryDropdown extends StatelessWidget {
  const CategoryDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(items: [], onChanged: (_) {});
  }
}
