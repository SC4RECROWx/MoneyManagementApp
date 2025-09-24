import 'package:flutter/material.dart';

class CancelButton extends StatelessWidget {
  final Function onPressed;
  final String label = "Cancel";

  const CancelButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onPressed(),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.red,
      ),
      child: Text(label),
    );
  }
}
