import 'package:flutter/material.dart';
import 'package:money_management_app/views/report/widgets/distribusi_chart.dart';
import 'package:money_management_app/views/report/widgets/kategori_pengeluaran.dart';
import 'package:money_management_app/views/report/pemasukan_pengeluaran_chart/pemasukan_pengeluaran_chart.dart';
import 'package:money_management_app/views/report/widgets/progres_budget_chart.dart';
import 'package:money_management_app/views/report/widgets/ringkasan_bulan_ini.dart';
import 'package:money_management_app/views/report/widgets/tren_saldo_bulanan.dart';
import 'package:money_management_app/views/shared/bottom_nav.dart';

class ReportPage extends StatelessWidget {
  const ReportPage({super.key});

  @override
  Widget build(BuildContext context) {
    double spacing = 32.0;
    return Scaffold(
      bottomNavigationBar: const BottomNav(currentIndex: 4),
      appBar: AppBar(title: const Text('Laporan Keuangan')),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          ProgressBudgetChart(),
          SizedBox(height: spacing),
          PemasukanPengeluaranChart(),
          SizedBox(height: spacing),
          RingkasanBulanIni(),
          SizedBox(height: spacing),
          TrenSaldoBulanan(),
        ],
      ),
    );
  }
}
