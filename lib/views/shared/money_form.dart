import 'package:flutter/material.dart';
import 'package:money_management_app/core/utils/utils.dart';
import 'package:money_management_app/views/shared/buttons/button.dart';

class MoneyFormField extends StatelessWidget {
  final int value; // Nilai uang yang sedang dipilih
  final ValueChanged<int> onValueChanged; // Callback ke parent
  final String label;
  final String? errorText;

  const MoneyFormField({
    super.key,
    required this.value,
    required this.onValueChanged,
    this.label = 'Masukkan Jumlah Uang',
    this.errorText,
  });

  // Fungsi untuk membangun custom number pad
  Widget _buildNumberPad(BuildContext context) {
    final buttons = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['C', '0', '<'],
    ];

    return Column(
      children: buttons.map((row) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: row.map((text) {
            if (text == 'C') {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Button(
                  onPressed: () {
                    int newValue = value;
                    newValue = 0;
                    onValueChanged(newValue);
                  },
                  label: text,
                  backgroundColor: Colors.red,
                ),
              );
            }
            if (text == '<') {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Button(
                  onPressed: () {
                    int newValue = value;
                    newValue = newValue ~/ 10;
                    onValueChanged(newValue);
                  },
                  label: text,
                  backgroundColor: Colors.red,
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Button(
                label: text,
                onPressed: () {
                  int newValue = value;
                  // if (text == 'C') {
                  //   newValue = 0;
                  // } else if (text == '<') {
                  //   newValue = newValue ~/ 10;
                  // } else {
                  //   newValue = int.tryParse('$newValue$text') ?? newValue;
                  // }
                  newValue = int.tryParse('$newValue$text') ?? newValue;
                  onValueChanged(newValue);
                },
              ),
            );
          }).toList(),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasError = errorText != null && errorText!.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Text(
                Utils.toIDR(value.toDouble()),
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 12),
              _buildNumberPad(context),
            ],
          ),
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 4.0),
            child: Text(
              errorText!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
