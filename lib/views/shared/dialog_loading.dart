import 'package:flutter/material.dart';

class DialogLoading extends StatelessWidget {
  const DialogLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
        ),
      ),
    );
  }

  static void show(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return const DialogLoading();
      },
    );
  }
}
