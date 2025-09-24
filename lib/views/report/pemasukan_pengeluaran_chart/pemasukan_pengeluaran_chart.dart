import 'package:flutter/material.dart';
import 'package:money_management_app/core/utils/utils.dart';
import 'package:money_management_app/models/expense_model.dart';
import 'package:money_management_app/models/income_model.dart';
import 'package:money_management_app/services/expense_service.dart';
import 'package:money_management_app/services/income_service.dart';
import 'package:money_management_app/widgets/custom_card.dart';
import 'components/pemasukan_pengeluaran_bar_chart.dart';
import 'components/legend_row.dart';
import 'components/dropdowns_row.dart';

class PemasukanPengeluaranChart extends StatefulWidget {
  const PemasukanPengeluaranChart({super.key});

  @override
  State<PemasukanPengeluaranChart> createState() =>
      _PemasukanPengeluaranChartState();
}

class _PemasukanPengeluaranChartState extends State<PemasukanPengeluaranChart> {
  List<IncomeModel> _incomeData = [];
  List<ExpenseModel> _expenseData = [];
  bool _isLoading = true;

  String _viewType = 'Tahunan';
  int _selectedMonth = DateTime.now().month - 1;
  int _selectedYear = DateTime.now().year;

  final List<String> _viewTypes = ['Tahunan', 'Bulanan'];
  final List<String> _months = Utils.getListMonthNames();

  @override
  void initState() {
    super.initState();
    _fetchChartData();
  }

  Future<void> _fetchChartData() async {
    final List<IncomeModel> incomes = await IncomeService.fetchAll();
    final List<ExpenseModel> expenses = await ExpenseService.fetchAll();

    setState(() {
      _incomeData = incomes;
      _expenseData = expenses;
      _isLoading = false;
    });
  }

  void _onViewTypeChanged(String? value) {
    if (value != null) setState(() => _viewType = value);
  }

  void _onMonthChanged(int? value) {
    if (value != null) setState(() => _selectedMonth = value);
  }

  void _onYearChanged(int? value) {
    if (value != null) setState(() => _selectedYear = value);
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      header: const Text('Pemasukan & Pengeluaran Bulanan'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownsRow(
            selectedYear: _selectedYear,
            viewType: _viewType,
            selectedMonth: _selectedMonth,
            viewTypes: _viewTypes,
            months: _months,
            onViewTypeChanged: _onViewTypeChanged,
            onMonthChanged: _onMonthChanged,
            onYearChanged: _onYearChanged,
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 250,
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : PemasukanPengeluaranBarChart(
                    viewType: _viewType,
                    selectedMonth: _selectedMonth,
                    selectedYear: _selectedYear,
                    incomeData: _incomeData,
                    expenseData: _expenseData,
                  ),
          ),
          const SizedBox(height: 50),
          const LegendRow(),
        ],
      ),
    );
  }
}
