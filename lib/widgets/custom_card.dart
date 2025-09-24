import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final Widget header;
  final Widget content;
  final Widget? footer;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  const CustomCard({
    super.key,
    required this.header,
    required this.content,
    this.footer,
    this.margin,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: margin ?? const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DefaultTextStyle(
              style:
                  theme.textTheme.titleLarge ??
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              child: header,
            ),
            const SizedBox(height: 12),
            DefaultTextStyle(
              style:
                  theme.textTheme.bodyMedium ?? const TextStyle(fontSize: 16),
              child: content,
            ),
            if (footer != null) ...[
              const SizedBox(height: 12),
              DefaultTextStyle(
                style:
                    theme.textTheme.labelMedium ??
                    const TextStyle(fontSize: 14, color: Colors.grey),
                child: footer!,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
