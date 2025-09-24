// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl/intl.dart';
import 'package:money_management_app/core/utils/utils.dart';
import 'package:money_management_app/models/budget_model.dart';
import 'package:money_management_app/models/kategori_model.dart';
import 'package:money_management_app/services/auth_service.dart';
import 'package:money_management_app/views/budget/blocs/budget_bloc.dart';
import 'package:money_management_app/views/budget/blocs/budget_event.dart';
import 'package:money_management_app/views/budget/blocs/budget_state.dart';
import 'package:money_management_app/views/kategori/bloc/kategori_bloc.dart';
import 'package:money_management_app/views/kategori/bloc/kategori_event.dart';
import 'package:money_management_app/views/kategori/views/kategori_form.dart';
import 'package:money_management_app/views/shared/alert/warning_alert.dart';
import 'package:money_management_app/views/shared/buttons/delete_button.dart';
import 'package:money_management_app/views/shared/buttons/save_button.dart';
import 'package:money_management_app/views/shared/money_form.dart';

class BudgetForm extends StatefulWidget {
  final BudgetModel? budget;

  const BudgetForm({super.key, this.budget});

  @override
  State<BudgetForm> createState() => _BudgetFormState();
}

class _BudgetFormState extends State<BudgetForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;
  String _range = 'monthly';
  List<KategoriModel> _kategoris = [];
  Color? _selectedColor;

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.budget != null) {
      _nameController.text = widget.budget?.name ?? '';
      _amountController.text = widget.budget?.amount.toString() ?? '0';
      _descriptionController.text = widget.budget?.description ?? '';
      _range = widget.budget?.range ?? 'monthly';
      _selectedMonth = widget.budget?.startAt.month ?? DateTime.now().month;
      _selectedYear = widget.budget?.startAt.year ?? DateTime.now().year;
      _kategoris = widget.budget?.kategoris ?? [];
      _selectedColor = widget.budget?.color ?? Colors.teal;
    }
  }

  Widget _buildColorPicker() {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: _selectedColor ?? Colors.teal,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: () async {
        final color = await showDialog<Color>(
          context: context,
          builder: (context) => AlertDialog(
            content: SingleChildScrollView(
              child: BlockPicker(
                pickerColor: _selectedColor ?? Colors.teal,
                onColorChanged: (color) {
                  Navigator.of(context).pop(color);
                },
              ),
            ),
          ),
        );
        if (color != null) {
          setState(() {
            _selectedColor = color;
          });
        }
      },
      child: const Text('', style: TextStyle(color: Colors.white)),
    );
  }

  // Helper for showing alerts
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

  // Fungsi untuk submit form budget (tambah/update)
  Future<void> _submit() async {
    try {
      if (_amountController.text.isEmpty ||
          double.tryParse(_amountController.text) == null ||
          double.parse(_amountController.text) <= 0) {
        _showWarning(
          'Validasi Gagal',
          'Jumlah budget harus diisi dengan angka yang valid dan tidak boleh nol.',
        );
        return;
      }
      if (_formKey.currentState!.validate()) {
        final startAt = DateTime(_selectedYear, _selectedMonth, 1);
        final endAt = DateTime(_selectedYear, _selectedMonth + 1, 0);
        final budget = BudgetModel(
          userId: await AuthService().getCurrentUserId(),
          id: widget.budget?.id,
          name: _nameController.text.trim(),
          amount: double.parse(_amountController.text.trim()),
          startAt: startAt,
          endAt: endAt,
          range: _range,
          description: _descriptionController.text.trim(),
          kategoris: _kategoris,
          color: _selectedColor ?? Colors.teal,
        );
        context.read<BudgetBloc>().add(
          widget.budget?.id == null
              ? CreateBudgetEvent(
                  budget: budget.copyWith(kategoris: () => _kategoris),
                )
              : UpdateBudgetEvent(
                  budget: budget.copyWith(kategoris: () => _kategoris),
                ),
        );
        // Navigation handled by BlocListener below
      }
    } catch (e) {
      _showWarning('Error', 'Terjadi kesalahan saat menyimpan budget: $e');
    }
  }

  // Widget untuk menampilkan field-field form budget
  Widget _buildBudgetFields() {
    final currentYear = DateTime.now().year;
    final years = List.generate(5, (i) => currentYear + i);
    final months = List.generate(12, (i) => i + 1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Data Budget',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 23),
        Row(
          children: [
            SizedBox(height: 48, child: _buildColorPicker()),
            const SizedBox(width: 16),
            Expanded(
              child: TextFormField(
                decoration: const InputDecoration(labelText: 'Nama Budget'),
                controller: _nameController,
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Nama budget wajib diisi'
                    : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 23),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<int>(
                value: _selectedMonth,
                decoration: InputDecoration(
                  labelText: 'Bulan',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: months
                    .map(
                      (m) => DropdownMenuItem(
                        value: m,
                        child: Text(
                          DateFormat('MMMM', 'id_ID').format(DateTime(0, m)),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedMonth = value ?? DateTime.now().month;
                  });
                },
              ),
            ),
            const SizedBox(width: 23),
            Expanded(
              child: DropdownButtonFormField<int>(
                value: _selectedYear,
                decoration: InputDecoration(
                  labelText: 'Tahun',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: years
                    .map(
                      (y) =>
                          DropdownMenuItem(value: y, child: Text(y.toString())),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedYear = value ?? DateTime.now().year;
                  });
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 23),
        MoneyFormField(
          value: double.tryParse(_amountController.text)!.toInt(),
          onValueChanged: (value) {
            setState(() {
              _amountController.text = value.toString();
            });
          },
        ),
      ],
    );
  }

  // Widget untuk menampilkan tombol simpan dan hapus budget
  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: SaveButton(onPressed: _submit, label: "Simpan"),
        ),
        if (widget.budget?.id != null) ...[
          const SizedBox(width: 8),
          DeleteButton(
            onPressed: () {
              context.read<BudgetBloc>().add(
                DeleteBudgetEvent(budget: widget.budget!),
              );
              // Navigation handled by BlocListener below
            },
          ),
        ],
      ],
    );
  }

  // Fungsi utama untuk membangun tampilan form budget
  @override
  Widget build(BuildContext context) {
    return BlocProvider<KategoriBloc>(
      create: (_) => KategoriBloc(),
      child: BlocListener<BudgetBloc, BudgetState>(
        listener: (context, state) {
          if (state is BudgetError) {
            _showWarning('Terjadi Kesalahan', state.message);
          }
          if (state is BudgetSuccess) {
            Navigator.pushReplacementNamed(context, '/budget');
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              widget.budget?.id == null ? 'Tambah Budget' : 'Edit Budget',
            ),
          ),
          body: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 24.0,
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildBudgetFields(),
                              const SizedBox(height: 24),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      _buildActionButtons(),
                    ],
                  ),
                ),
              ),
              BlocBuilder<BudgetBloc, BudgetState>(
                builder: (context, state) {
                  if (state is BudgetLoading) {
                    return Container(
                      color: Colors.black.withOpacity(0.2),
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
