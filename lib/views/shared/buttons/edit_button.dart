import 'package:flutter/material.dart';

class EditButton extends StatelessWidget {
  final Function onPressed;
  final String? label;
  final IconData? icon;

  const EditButton({super.key, required this.onPressed, this.label, this.icon});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        onPressed();
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
      ),
      child: Row(
        spacing: 8,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon ?? Icons.edit, color: Colors.white),
          Text(label ?? 'Edit'),
        ],
      ),
    );
  }
}
