import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final Function onPressed;
  final String label;
  final Color? backgroundColor;

  const Button({
    super.key,
    required this.onPressed,
    required this.label,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => onPressed(),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
      ),
      child: Text(label),
    );
  }
}
