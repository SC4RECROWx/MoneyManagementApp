import 'package:flutter/material.dart';
import 'package:money_management_app/core/utils/utils.dart';
import 'package:money_management_app/models/budget_model.dart';
import 'package:money_management_app/models/expense_model.dart';
import 'package:money_management_app/models/kategori_model.dart';
import 'package:money_management_app/services/budget_service.dart';
import 'package:money_management_app/services/expense_service.dart';
import 'package:money_management_app/services/kategori_services.dart';
import 'package:money_management_app/widgets/custom_card.dart';

class KategoriPengeluaranData {
  String kategori;
  String budget;
  double total;
  Color color;

  KategoriPengeluaranData({
    required this.kategori,
    required this.budget,
    required this.total,
    required this.color,
  });
}

class KategoriPengeluaran extends StatefulWidget {
  const KategoriPengeluaran({super.key});

  @override
  State<KategoriPengeluaran> createState() => _KategoriPengeluaranState();
}

class _KategoriPengeluaranState extends State<KategoriPengeluaran> {
  List<KategoriPengeluaranData> categoryData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAndProcessExpenses();
  }

  Future<void> fetchAndProcessExpenses() async {
    final kategoriListFuture = KategoriService.fetchAll();
    final expensesFuture = ExpenseService.fetchAll();
    final budgetsFuture = BudgetService.fetchAll();

    final results = await Future.wait([
      kategoriListFuture,
      expensesFuture,
      budgetsFuture,
    ]);
    final kategoriList = results[0] as List<KategoriModel>;
    final expenses = results[1] as List<ExpenseModel>;
    final budgets = results[2] as List<BudgetModel>;

    // Map for quick lookup
    final budgetNameMap = {for (var b in budgets) b.id: b.name};
    final kategoriMap = {for (var k in kategoriList) k.id: k};

    // Aggregate expenses by kategoriId
    final Map<String, double> kategoriTotals = {};
    for (var expense in expenses) {
      if (kategoriMap.containsKey(expense.kategoriId)) {
        kategoriTotals.update(
          expense.kategoriId,
          (v) => v + expense.amount,
          ifAbsent: () => expense.amount,
        );
      }
    }

    // Build the list
    final kategoriPengeluaranList = kategoriTotals.entries.map((entry) {
      final kategori = kategoriMap[entry.key]!;
      return KategoriPengeluaranData(
        kategori: kategori.kategori,
        budget: budgetNameMap[kategori.budgetId] ?? 'Tanpa Anggaran',
        total: entry.value,
        color: kategori.color!,
      );
    }).toList();

    kategoriPengeluaranList.sort((a, b) => b.total.compareTo(a.total));

    if (!mounted) return;

    setState(() {
      categoryData = kategoriPengeluaranList;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      header: const Text('Kategori Pengeluaran Terbesar'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 18),
          isLoading ? CircularProgressIndicator() : SizedBox.shrink(),
          ...isLoading
              ? []
              : categoryData.isEmpty
              ? [const Text('Tidak ada data')]
              : [
                  ...categoryData
                      .toList()
                      .where((d) => (d.total as num) > 0)
                      .toList()
                      .map(
                        (data) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: data.color,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Tooltip(
                                  message: data.budget,
                                  child: Text(
                                    data.kategori,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              Text(Utils.toIDR(data.total)),
                            ],
                          ),
                        ),
                      ),
                ],
        ],
      ),
    );
  }
}
