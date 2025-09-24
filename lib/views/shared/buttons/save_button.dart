import 'package:flutter/material.dart';

class SaveButton extends StatelessWidget {
  final Function onPressed;
  final String label;

  const SaveButton({super.key, required this.onPressed, this.label = "Simpan"});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onPressed(),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      child: Text(label),
    );
  }
}
