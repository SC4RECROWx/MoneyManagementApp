import 'package:flutter/material.dart';

class AddButton extends StatelessWidget {
  final Function onPressed;
  const AddButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
      ),
      child: IconButton(
        icon: const Icon(Icons.add, color: Color(0xFF1B233A)),
        onPressed: () => onPressed(),
      ),
    );
  }
}
