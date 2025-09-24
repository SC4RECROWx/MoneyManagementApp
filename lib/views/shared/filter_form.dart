import 'package:flutter/material.dart';
import 'package:money_management_app/models/budget_model.dart';
import 'package:money_management_app/models/filter_model.dart';
import 'package:money_management_app/views/shared/buttons/save_button.dart';

class FilterForm extends StatefulWidget {
  final FilterModel? filter;
  final void Function(FilterModel filter) onFilter;
  final List<BudgetModel>? budgets;

  const FilterForm({
    super.key,
    required this.onFilter,
    this.budgets,
    this.filter,
  });

  @override
  State<FilterForm> createState() => _FilterFormState();
}

class _FilterFormState extends State<FilterForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();

  String? _selectedBudgetId;

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final budgetId = _selectedBudgetId ?? '';
      final from = _fromController.text.isNotEmpty
          ? double.tryParse(_fromController.text)
          : null;
      final to = _toController.text.isNotEmpty
          ? double.tryParse(_toController.text)
          : null;
      widget.onFilter(FilterModel(budgetId: budgetId, from: from, to: to));
    }
  }

  @override
  void initState() {
    super.initState();
    _selectedBudgetId = widget.filter?.budgetId;
    _fromController.text = widget.filter?.from?.toString() ?? '';
    _toController.text = widget.filter?.to?.toString() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.budgets != null && widget.budgets!.isNotEmpty
              ? DropdownButtonFormField<String>(
                  value: _selectedBudgetId,
                  decoration: const InputDecoration(labelText: 'Pilih Budget'),
                  items: widget.budgets!
                      .map(
                        (budget) => DropdownMenuItem<String>(
                          value: budget.id,
                          child: Text(budget.name),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedBudgetId = value;
                    });
                  },
                  validator: (value) => value == null || value.isEmpty
                      ? 'Budget wajib dipilih'
                      : null,
                )
              : const SizedBox.shrink(),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _fromController,
                  decoration: const InputDecoration(labelText: 'Jumlah Dari'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      final num = double.tryParse(value);
                      if (num == null || num < 0) {
                        return 'Masukkan jumlah yang valid';
                      }
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _toController,
                  decoration: const InputDecoration(labelText: 'Jumlah Sampai'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      final num = double.tryParse(value);
                      if (num == null || num < 0) {
                        return 'Masukkan jumlah yang valid';
                      }
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: SaveButton(onPressed: _submit, label: 'Filter'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
