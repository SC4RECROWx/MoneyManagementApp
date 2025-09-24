import 'package:flutter/material.dart';
import 'package:money_management_app/views/shared/alert/alert.dart';

class WarningAlert {
  static Future<void> show({
    required BuildContext context,
    required String title,
    required String message,
    required List<Widget> actions,
  }) {
    return Alert.show(
      context: context,
      title: title,
      message: message,
      icon: Icons.warning,
      iconColor: Colors.orange,
      actions: actions,
    );
  }
}
