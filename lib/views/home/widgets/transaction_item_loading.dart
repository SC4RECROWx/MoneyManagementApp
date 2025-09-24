import 'package:flutter/material.dart';

class TransactionItemLoading extends StatefulWidget {
  const TransactionItemLoading({super.key});

  @override
  State<TransactionItemLoading> createState() => _TransactionItemLoadingState();
}

class _TransactionItemLoadingState extends State<TransactionItemLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _animation = Tween<double>(
      begin: 0.6,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildItem() {
    return FadeTransition(
      opacity: _animation,
      child: Row(
        children: [
          // Avatar shimmer
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 16),
          // Text shimmer
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 16, width: 120, color: Colors.grey.shade300),
                const SizedBox(height: 8),
                Container(height: 12, width: 80, color: Colors.grey.shade300),
                const SizedBox(height: 12),
                Container(
                  height: 8,
                  width: double.infinity,
                  color: Colors.grey.shade200,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 30, 24, 0),
        child: Column(
          spacing: 20,
          children: [_buildItem(), _buildItem(), _buildItem()],
        ),
      ),
    );
  }
}
