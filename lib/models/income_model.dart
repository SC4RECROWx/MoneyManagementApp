class IncomeModel {
  final String id;
  final double amount;
  final String source;
  final DateTime createAt;
  // final String budgetId; // Budget tujuan pemasukan (ZBB)
  final String userId; // Budget tujuan pemasukan (ZBB)

  final String description; // Penjelasan tambahan

  IncomeModel({
    DateTime? createAt,
    required this.id,
    required this.amount,
    required this.source,
    required this.userId,
    this.description = '',
  }) : createAt = createAt ?? DateTime.now();

  @override
  String toString() {
    return 'IncomeModel(id: $id, amount: $amount, source: $source, createAt: $createAt, userId: $userId, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is IncomeModel &&
        other.id == id &&
        other.amount == amount &&
        other.source == source &&
        other.createAt == createAt &&
        other.userId == userId &&
        other.description == description;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        amount.hashCode ^
        source.hashCode ^
        createAt.hashCode ^
        userId.hashCode ^
        description.hashCode;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'source': source,
      'createAt': createAt.millisecondsSinceEpoch,
      'userId': userId,
      'description': description,
    };
  }

  factory IncomeModel.fromMap(Map<String, dynamic> map) {
    return IncomeModel(
      id: map['id'] ?? '',
      amount: map['amount']?.toDouble() ?? 0.0,
      source: map['source'] ?? '',
      createAt: DateTime.fromMillisecondsSinceEpoch(map['createAt']),
      userId: map['userId'] ?? '',
      description: map['description'] ?? '',
    );
  }

  IncomeModel copyWith({
    String? id,
    double? amount,
    String? source,
    DateTime? createAt,
    String? userId,
    String? description,
  }) {
    return IncomeModel(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      source: source ?? this.source,
      createAt: createAt ?? this.createAt,
      userId: userId ?? this.userId,
      description: description ?? this.description,
    );
  }
}
