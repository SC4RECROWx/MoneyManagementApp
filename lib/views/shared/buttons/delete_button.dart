import 'package:flutter/material.dart';

class DeleteButton extends StatelessWidget {
  final Function onPressed;

  const DeleteButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onPressed(),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: Colors.red,
      ),
      child: Icon(Icons.delete, color: Colors.white),
    );
  }
}
