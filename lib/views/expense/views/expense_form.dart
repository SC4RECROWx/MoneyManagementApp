import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:money_management_app/models/budget_model.dart';
import 'package:money_management_app/models/expense_model.dart';
import 'package:money_management_app/models/kategori_model.dart';
import 'package:money_management_app/services/auth_service.dart';
import 'package:money_management_app/views/expense/blocs/expense_bloc.dart';
import 'package:money_management_app/views/expense/blocs/expense_event.dart';
import 'package:money_management_app/views/shared/alert/warning_alert.dart';

import 'package:money_management_app/views/shared/buttons/delete_button.dart';
import 'package:money_management_app/views/shared/buttons/save_button.dart';
import 'package:money_management_app/views/shared/money_form.dart';

class ExpenseForm extends StatefulWidget {
  final Function(ExpenseModel expense) onSubmit;
  final ExpenseModel? expense;
  final List<BudgetModel> budgets; // Tambahkan list budget

  const ExpenseForm({
    super.key,
    required this.onSubmit,
    this.expense,
    required this.budgets,
  });

  @override
  State<ExpenseForm> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  final _formKey = GlobalKey<FormState>();
  final _sourceController = TextEditingController();
  final _amountController = TextEditingController();
  String? _selectedBudgetId;

  double spacing = 12.0;

  @override
  void dispose() {
    _sourceController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _sourceController.text = widget.expense?.source ?? '';
    _amountController.text = widget.expense?.amount.toString() ?? '0';
    _selectedBudgetId =
        widget.expense?.budgetId ??
        (widget.budgets.isNotEmpty ? widget.budgets.first.id : null);
  }

  void _showWarning(String title, String message) {
    WarningAlert.show(
      title: title,
      context: context,
      message: message,
      actions: [
        Expanded(
          child: SaveButton(
            onPressed: () => Navigator.pop(context),
            label: "OK",
          ),
        ),
      ],
    );
  }

  void _submit() async {
    if (_amountController.text.isEmpty ||
        double.tryParse(_amountController.text) == null ||
        double.parse(_amountController.text) <= 0) {
      _showWarning(
        'Validasi Gagal',
        'Jumlah harus diisi dengan angka yang valid dan tidak boleh nol.',
      );
      return;
    }
    if (_formKey.currentState!.validate()) {
      final source = _sourceController.text.trim();
      final amount = double.parse(_amountController.text.trim());
      final userId = await AuthService().getCurrentUserId();

      widget.onSubmit(
        ExpenseModel(
          id: widget.expense?.id ?? '',
          kategoriId: '',
          budgetId: _selectedBudgetId!,
          userId: userId,
          source: source,
          amount: amount,
          createAt: DateTime.now(),
        ),
      );
      _sourceController.clear();
      _amountController.clear();
    }
  }

  void _deleteExpense(ExpenseModel expense) {
    context.read<ExpenseBloc>().add(DeleteExpenseEvent(expense: expense));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        // SingleChildScrollView agar tidak stretch ke bawah
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // Tambahkan ini!
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Budget'),
              value: _selectedBudgetId,
              items: widget.budgets
                  .map(
                    (budget) => DropdownMenuItem(
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
              validator: (value) =>
                  value == null || value.isEmpty ? 'Pilih budget' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Nama Transaksi'),
              controller: _sourceController,
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Sumber wajib diisi'
                  : null,
            ),
            const SizedBox(height: 12),
            MoneyFormField(
              value: double.tryParse(_amountController.text)!.toInt(),
              onValueChanged: (value) {
                setState(() {
                  _amountController.text = value.toString();
                });
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: SaveButton(onPressed: _submit)),
                if (widget.expense != null) const SizedBox(width: 12),
                if (widget.expense != null)
                  DeleteButton(
                    onPressed: () => _deleteExpense(widget.expense!),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
