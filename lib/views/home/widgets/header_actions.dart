import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_management_app/services/auth_service.dart';
import 'package:money_management_app/views/home/bloc/home_bloc.dart';
import 'package:money_management_app/views/home/bloc/home_state.dart';
import 'circle_icon_button.dart';

class HeaderActions extends StatelessWidget {
  const HeaderActions({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Row(
          spacing: 0,
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: AssetImage(context.read<HomeBloc>().avatar),
            ),
            const Spacer(),
            Tooltip(
              message: "Pengaturan",
              child: CircleIconButton(
                icon: Icons.settings,
                onPressed: () {
                  Navigator.pushNamed(context, '/settings');
                },
              ),
            ),
            Tooltip(
              message: "Keluar",
              child: CircleIconButton(
                icon: Icons.logout,
                onPressed: () async {
                  await AuthService().logout();
                  // ignore: use_build_context_synchronously
                  Navigator.pushReplacementNamed(context, '/login');
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
