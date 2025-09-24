import 'package:flutter/material.dart';
import 'package:money_management_app/models/kategori_model.dart';

class KategoriPickers extends StatelessWidget {
  final List<KategoriModel> categories;
  final KategoriModel? selectedCategory;
  final ValueChanged<KategoriModel> onCategorySelected;
  final String label;
  final String? errorText; // Add errorText for validation

  const KategoriPickers({
    super.key,
    required this.categories,
    required this.selectedCategory,
    required this.onCategorySelected,
    this.label = 'Pilih Kategori',
    this.errorText, // Accept errorText
  });

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null && errorText!.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border.all(color: hasError ? Colors.red : Colors.grey),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: categories.isEmpty
              ? const Text('No categories available')
              : Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  alignment: WrapAlignment.center,
                  spacing: 8.0,
                  children: categories.map((category) {
                    final isSelected = category == selectedCategory;
                    return ChoiceChip(
                      selectedColor: Theme.of(context).colorScheme.primary,
                      label: Text(category.kategori),
                      selected: isSelected,
                      onSelected: (_) => onCategorySelected(category),
                    );
                  }).toList(),
                ),
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 4.0),
            child: Text(
              errorText!,
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
