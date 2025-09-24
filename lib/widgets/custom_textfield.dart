import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {
  final TextEditingController controller;
  const CustomTextfield({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: 'Jumlah (Rp)',
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: const Color(0xFF232B47),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) return 'Jumlah wajib diisi';
        final numValue = int.tryParse(value.trim());
        if (numValue == null || numValue <= 0) return 'Jumlah harus > 0';
        return null;
      },
    );
  }
}
