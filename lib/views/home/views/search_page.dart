import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_management_app/core/utils/utils.dart';
import 'package:money_management_app/views/home/bloc/home_bloc.dart';
import 'package:money_management_app/views/home/bloc/home_event.dart';
import 'package:money_management_app/views/home/bloc/home_state.dart';
import 'package:money_management_app/views/home/widgets/transaction_item.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pencarian'),
        backgroundColor: Colors.teal,
      ),
      body: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is HomeError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: const InputDecoration(
                  hintText: 'Cari transaksi...',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.toLowerCase();
                  });
                },
              ),
            ),
            Expanded(
              child: BlocBuilder<HomeBloc, HomeState>(
                builder: (context, state) {
                  if (state is HomeInitial) {
                    context.read<HomeBloc>().add(LoadHomeData());
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is HomeLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is HomeLoaded) {
                    final filteredTransactions = state.transactions.where((
                      transaction,
                    ) {
                      return transaction.source.toLowerCase().contains(
                        _searchQuery,
                      );
                    }).toList();

                    if (filteredTransactions.isEmpty) {
                      return const Center(
                        child: Text("Tidak ada transaksi ditemukan"),
                      );
                    }

                    return ListView.builder(
                      itemCount: filteredTransactions.length,
                      itemBuilder: (context, index) {
                        final transaction = filteredTransactions[index];
                        return TransactionItem(
                          title: transaction.source,
                          subtitle: Utils.timeAgo(transaction.createAt),
                          amount: transaction.amount,
                          type: transaction.type,
                          margin: const EdgeInsets.all(0),
                          // padding: const EdgeInsets.all(18),
                          borderRadius: const Radius.circular(0),
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: Text("Error loading transactions"),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
