import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_management_app/core/utils/utils.dart';
import 'package:money_management_app/views/home/bloc/home_bloc.dart';
import 'package:money_management_app/views/home/bloc/home_event.dart';
import 'package:money_management_app/views/home/bloc/home_state.dart';
import 'package:money_management_app/views/home/widgets/transaction_item_loading.dart';

import '../../shared/bottom_nav.dart';
import '../widgets/home_header.dart';
import '../widgets/history_header.dart';
import '../widgets/transaction_item.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNav(),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<HomeBloc>().add(LoadHomeData());
          await Future.delayed(const Duration(seconds: 1));
        },
        child: Column(
          children: [
            const HomeHeader(),
            Expanded(
              child: BlocListener<HomeBloc, HomeState>(
                listener: (context, state) {
                  if (state is HomeError) {
                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(state.message)));
                  }
                },
                child: BlocBuilder<HomeBloc, HomeState>(
                  builder: (context, state) {
                    if (state is HomeInitial) {
                      context.read<HomeBloc>().add(LoadHomeData());
                      return const TransactionItemLoading();
                    }

                    if (state is HomeLoading) {
                      return const TransactionItemLoading();
                    } else if (state is HomeLoaded) {
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                        child: Column(
                          children: [
                            const HistoryHeader(),
                            const SizedBox(height: 18),
                            Expanded(
                              child: ListView.builder(
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemCount: state.transactions.length,
                                itemBuilder: (context, index) {
                                  final transaction = state.transactions[index];
                                  return TransactionItem(
                                    title: transaction.source,
                                    subtitle: Utils.timeAgo(
                                      transaction.createAt,
                                    ),
                                    amount: transaction.amount,
                                    type: transaction.type,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      );
                    } else {
                      return const Center(
                        child: Text("Error loading transactions"),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
