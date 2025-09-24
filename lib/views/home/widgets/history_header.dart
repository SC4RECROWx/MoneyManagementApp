import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_management_app/views/home/bloc/home_bloc.dart';
import 'package:money_management_app/views/home/views/search_page.dart';

class HistoryHeader extends StatelessWidget {
  const HistoryHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Text(
          "History",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const Spacer(),
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return BlocProvider(
                    create: (context) => HomeBloc(),
                    child: const SearchPage(),
                  );
                },
              ),
            );
          },
          icon: const Icon(Icons.search, color: Colors.grey),
        ),
      ],
    );
  }
}
