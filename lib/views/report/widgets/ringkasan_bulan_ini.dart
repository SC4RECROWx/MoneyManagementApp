import 'package:flutter/material.dart';
import 'package:money_management_app/core/utils/utils.dart';
import 'package:money_management_app/models/expense_model.dart';
import 'package:money_management_app/models/income_model.dart';
import 'package:money_management_app/services/expense_service.dart';
import 'package:money_management_app/services/income_service.dart';
import 'package:money_management_app/views/report/widgets/summary_info.dart';
import 'package:money_management_app/widgets/custom_card.dart';

class RingkasanBulanIni extends StatefulWidget {
  const RingkasanBulanIni({super.key});

  @override
  State<RingkasanBulanIni> createState() => _RingkasanBulanIniState();
}

class _RingkasanBulanIniState extends State<RingkasanBulanIni> {
  double incomeTotal = 0;
  double expenseTotal = 0;
  bool isLoading = true;

  Future<void> _fetchData() async {
    final List<IncomeModel> incomeSnapshot = await IncomeService.fetchAll();
    final List<ExpenseModel> expenseSnapshot = await ExpenseService.fetchAll();

    setState(() {
      incomeTotal = incomeSnapshot.fold(0, (sum, doc) => sum + doc.amount);
      expenseTotal = expenseSnapshot.fold(0, (sum, doc) => sum + doc.amount);
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      header: const Text('Ringkasan Bulan Ini'),
      content: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (isLoading)
              const CircularProgressIndicator()
            else ...[
              SummaryInfo(
                label: 'Pemasukan',
                value: Utils.toIDR(incomeTotal),
                color: Colors.green,
              ),
              const SizedBox(width: 24),
              SummaryInfo(
                label: 'Pengeluaran',
                value: Utils.toIDR(expenseTotal),
                color: Colors.red,
              ),
              const SizedBox(width: 24),
              SummaryInfo(
                label: 'Saldo',
                value: Utils.toIDR(incomeTotal - expenseTotal),
                color: Colors.blue,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
