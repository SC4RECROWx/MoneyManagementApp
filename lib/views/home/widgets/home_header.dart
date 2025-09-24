import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_management_app/core/utils/utils.dart';
import 'package:money_management_app/views/home/bloc/home_bloc.dart';
import 'package:money_management_app/views/home/bloc/home_state.dart';
import 'header_actions.dart';
import 'add_button.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  Widget _buildHeaderLoading(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HeaderActions(),
        const SizedBox(height: 18),
        const Text(
          "Selamat Datang,",
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
        Text(
          context.read<HomeBloc>().userName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FadeTransition(
                  opacity: AlwaysStoppedAnimation(1.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 16,
                        width: 40,
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        height: 12,
                        width: 80,
                        color: Colors.grey.shade300,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Spacer(),
            AddButton(
              onPressed: () {
                Navigator.pushNamed(context, '/income');
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeaderError(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HeaderActions(),
        const SizedBox(height: 18),
        const Text(
          "Selamat Datang,",
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
        Text(
          context.read<HomeBloc>().userName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Saldo Sekarang",
                  style: TextStyle(color: Colors.white70, fontSize: 15),
                ),
                Text(
                  '* * * * * * *',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            const Spacer(),
            AddButton(
              onPressed: () {
                Navigator.pushNamed(context, '/income');
              },
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 48, 24, 24),
      decoration: const BoxDecoration(
        color: Colors.teal,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return _buildHeaderLoading(context);
          }

          if (state is HomeLoaded) {
            final double saldo =
                state.transactions
                    .where((transaction) => transaction.type == 'income')
                    .fold(0.0, (sum, item) => sum + item.amount) -
                state.transactions
                    .where((transaction) => transaction.type == 'expense')
                    .fold(0.0, (sum, item) => sum + item.amount);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const HeaderActions(),
                const SizedBox(height: 18),
                const Text(
                  "Selamat Datang,",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                Text(
                  context.read<HomeBloc>().userName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Saldo Sekarang",
                          style: TextStyle(color: Colors.white70, fontSize: 15),
                        ),
                        Text(
                          Utils.toIDR(saldo),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    AddButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/income');
                      },
                    ),
                  ],
                ),
              ],
            );
          }

          return _buildHeaderError(context);
        },
      ),
    );
  }
}
