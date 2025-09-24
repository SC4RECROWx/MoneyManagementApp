import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import 'package:money_management_app/models/kategori_model.dart';
import 'package:money_management_app/services/auth_service.dart';

import 'package:money_management_app/views/shared/buttons/save_button.dart';
import 'package:money_management_app/views/shared/money_form.dart';

class KategoriForm extends StatefulWidget {
  final Function(KategoriModel kategori) onSubmit;
  final KategoriModel? kategori;

  const KategoriForm({super.key, required this.onSubmit, this.kategori});

  @override
  State<KategoriForm> createState() => _KategoriFormState();
}

class _KategoriFormState extends State<KategoriForm> {
  final _formKey = GlobalKey<FormState>();
  final _kategoriController = TextEditingController();
  final _plannedController = TextEditingController();
  Color? _selectedColor;

  double spacing = 12.0;

  @override
  void dispose() {
    _kategoriController.dispose();
    _plannedController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _kategoriController.text = widget.kategori?.kategori ?? '';
    _plannedController.text = widget.kategori?.planned.toString() ?? '0';
    _selectedColor = widget.kategori?.color ?? Colors.grey[300];
  }

  /// Fungsi untuk submit form kategori ke parent widget
  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final kategori = _kategoriController.text.trim();
      final planned = double.parse(_plannedController.text.trim());
      final userId = await AuthService().getCurrentUserId();

      widget.onSubmit(
        KategoriModel(
          id: widget.kategori?.id,
          userId: userId,
          kategori: kategori,
          planned: planned,
          createdAt: DateTime.now(),
          color: _selectedColor ?? const Color(0xFF000000),
          budgetId: widget.kategori?.budgetId ?? '',
        ),
      );
      if (widget.kategori == null) {
        _kategoriController.clear();
        _plannedController.clear();
      }
    }
  }

  /// Widget untuk input nama kategori
  Widget _buildKategoriField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Jenis Transaksi'),
      controller: _kategoriController,
      validator: (value) => value == null || value.trim().isEmpty
          ? 'Jenis Transaksi wajib diisi'
          : null,
    );
  }

  /// Widget untuk input nilai planned menggunakan MoneyFormField
  Widget _buildPlannedField() {
    return MoneyFormField(
      value: double.tryParse(_plannedController.text)!.toInt(),
      onValueChanged: (value) {
        setState(() {
          _plannedController.text = value.toString();
        });
      },
    );
  }

  /// Widget untuk memilih warna kategori
  Widget _buildColorPicker() {
    return TextButton(
      style: TextButton.styleFrom(
        backgroundColor: _selectedColor ?? Colors.grey[300],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      onPressed: () async {
        final color = await showDialog<Color>(
          context: context,
          builder: (context) => AlertDialog(
            content: SingleChildScrollView(
              child: BlockPicker(
                pickerColor: _selectedColor ?? Colors.grey[300]!,
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

  /// Widget untuk tombol aksi (simpan dan batal)
  Widget _buildActionButtons() {
    return Row(
      children: [Expanded(child: SaveButton(onPressed: _submit))],
    );
  }

  /// Fungsi utama membangun tampilan form kategori
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              _buildColorPicker(),
              const SizedBox(width: 12),
              Expanded(child: _buildKategoriField()),
            ],
          ),
          const SizedBox(height: 12),
          _buildPlannedField(),
          _buildActionButtons(),
        ],
      ),
    );
  }
}
