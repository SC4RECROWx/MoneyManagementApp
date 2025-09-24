import 'package:flutter/material.dart';
import 'package:money_management_app/models/income_model.dart';
import 'package:money_management_app/services/auth_service.dart';
import 'package:money_management_app/models/budget_model.dart';
import 'package:money_management_app/views/income/bloc/income_bloc.dart';
import 'package:money_management_app/views/income/bloc/income_event.dart';
import 'package:money_management_app/views/shared/buttons/delete_button.dart';
import 'package:money_management_app/views/shared/buttons/save_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_management_app/views/shared/money_form.dart';

class IncomeForm extends StatefulWidget {
  final Function(IncomeModel income) onSubmit;
  final IncomeModel? income;
  final List<BudgetModel> budgets;

  const IncomeForm({
    super.key,
    required this.onSubmit,
    this.income,
    required this.budgets,
  });

  @override
  State<IncomeForm> createState() => _IncomeFormState();
}

class _IncomeFormState extends State<IncomeForm> {
  final _formKey = GlobalKey<FormState>();
  final _sourceController = TextEditingController();
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _sourceController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _sourceController.text = widget.income?.source ?? '';
    _amountController.text = widget.income?.amount.toString() ?? '';
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final source = _sourceController.text.trim();
      final amount = double.parse(_amountController.text.trim());
      final userId = await AuthService().getCurrentUserId();

      widget.onSubmit(
        IncomeModel(
          userId: userId,
          id: widget.income?.id ?? '',
          source: source,
          amount: amount,
          createAt: DateTime.now(),
        ),
      );
      _sourceController.clear();
      _amountController.clear();
    }
  }

  void _deleteIncome(IncomeModel income) {
    context.read<IncomeBloc>().add(DeleteIncomeEvent(income: income));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Nama Transaksi'),
              controller: _sourceController,
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Sumber wajib diisi'
                  : null,
            ),
            const SizedBox(height: 12),
            MoneyFormField(
              value: (double.tryParse(_amountController.text) ?? 0).toInt(),
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
                if (widget.income != null) ...[
                  const SizedBox(width: 12),
                  DeleteButton(onPressed: () => _deleteIncome(widget.income!)),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
