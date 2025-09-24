class ExpenseModel {
  final String id;
  final double amount;
  final String source;
  final DateTime createAt;
  final String budgetId; // Budget tujuan pengeluaran (ZBB)
  final String kategoriId; // Kategori tujuan pengeluaran (ZBB)
  final String userId; // User ID untuk pengeluaran

  ExpenseModel({
    DateTime? createAt,
    required this.id,
    required this.amount,
    required this.source,
    required this.budgetId,
    required this.kategoriId,
    required this.userId,
  }) : createAt = createAt ?? DateTime.now();

  ExpenseModel copyWith({
    String? id,
    double? amount,
    String? source,
    DateTime? createAt,
    String? budgetId,
    String? kategoriId,
    String? userId,
  }) {
    return ExpenseModel(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      source: source ?? this.source,
      createAt: createAt ?? this.createAt,
      budgetId: budgetId ?? this.budgetId,
      kategoriId: kategoriId ?? this.kategoriId,
      userId: userId ?? this.userId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'source': source,
      'createAt': createAt.millisecondsSinceEpoch,
      'budgetId': budgetId,
      'kategoriId': kategoriId,
      'userId': userId,
    };
  }

  factory ExpenseModel.fromMap(Map<String, dynamic> map) {
    return ExpenseModel(
      id: map['id'] ?? '',
      amount: map['amount']?.toDouble() ?? 0.0,
      source: map['source'] ?? '',
      createAt: DateTime.fromMillisecondsSinceEpoch(map['createAt']),
      budgetId: map['budgetId'] ?? '',
      kategoriId: map['kategoriId'] ?? '',
      userId: map['userId'] ?? '',
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ExpenseModel &&
        other.id == id &&
        other.amount == amount &&
        other.source == source &&
        other.createAt == createAt &&
        other.budgetId == budgetId &&
        other.kategoriId == kategoriId &&
        other.userId == userId;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        amount.hashCode ^
        source.hashCode ^
        createAt.hashCode ^
        budgetId.hashCode ^
        kategoriId.hashCode ^
        userId.hashCode;
  }
}
