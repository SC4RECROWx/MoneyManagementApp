// app_version: 1.0.0
// app_version: 2.0.0

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_management_app/views/budget/blocs/budget_bloc.dart';
import 'package:money_management_app/views/expense/blocs/expense_bloc.dart';
import 'package:money_management_app/views/home/bloc/home_bloc.dart';
import 'package:money_management_app/views/income/bloc/income_bloc.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:money_management_app/core/theme/app_theme.dart';
import 'package:money_management_app/core/theme/theme_provider.dart';
import 'package:money_management_app/views/home/views/home_page.dart';
import 'package:money_management_app/views/auth/login_page.dart';
import 'package:money_management_app/views/auth/register_page.dart';
import 'package:money_management_app/views/income/views/income_page.dart';
import 'package:money_management_app/views/expense/views/expense_page.dart';
import 'package:money_management_app/views/budget/views/budget_page.dart';
import 'package:money_management_app/views/report/report_page.dart';
import 'package:money_management_app/views/settings/setting_page.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_auth/firebase_auth.dart';

final routes = {
  // Remove '/' from here, we'll handle it in MaterialApp
  '/income': (context) =>
      BlocProvider(create: (_) => IncomeBloc(), child: IncomePage()),
  '/expense': (context) =>
      BlocProvider(create: (_) => ExpenseBloc(), child: ExpensePage()),
  '/budget': (context) =>
      BlocProvider(create: (_) => BudgetBloc(), child: BudgetPage()),
  '/report': (context) => ReportPage(),
  '/login': (context) => LoginPage(),
  '/settings': (context) => SettingPage(),
  '/logout': (context) => LoginPage(),
  '/register': (context) => RegisterPage(),
};

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  Route<dynamic>? _onGenerateRoute(RouteSettings settings) {
    WidgetBuilder builder;
    switch (settings.name) {
      case '/income':
        builder = (context) =>
            BlocProvider(create: (_) => IncomeBloc(), child: IncomePage());
        break;
      case '/expense':
        builder = (context) =>
            BlocProvider(create: (_) => ExpenseBloc(), child: ExpensePage());
        break;
      case '/budget':
        builder = (context) =>
            BlocProvider(create: (_) => BudgetBloc(), child: BudgetPage());
        break;
      case '/report':
        builder = (context) => ReportPage();
        break;
      case '/settings':
        builder = (context) => SettingPage();
        break;
      case '/register':
        builder = (context) => RegisterPage();
        break;
      case '/login':
      case '/logout':
        builder = (context) => LoginPage();
        break;
      default:
        builder = (context) =>
            BlocProvider(create: (_) => HomeBloc(), child: HomePage());
    }

    // Middleware: check auth
    return MaterialPageRoute(
      builder: (context) {
        final user = FirebaseAuth.instance.currentUser;
        // If not logged in, redirect to login except for login/register routes
        if (user == null &&
            settings.name != '/login' &&
            settings.name != '/register') {
          return LoginPage();
        }
        return builder(context);
      },
      settings: settings,
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeProvider.themeMode,
      title: 'Zero Based Budgeting',
      initialRoute: '/',
      onGenerateRoute: _onGenerateRoute, // <-- Use this instead of routes:
    );
  }
}
