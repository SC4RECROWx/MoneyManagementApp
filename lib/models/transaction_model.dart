import 'package:equatable/equatable.dart';

class TransactionModel extends Equatable {
  final String id;
  final double amount;
  final String source;
  final DateTime createAt;
  final String type;

  const TransactionModel({
    required this.id,
    required this.amount,
    required this.source,
    required this.createAt,
    required this.type,
  });

  @override
  List<Object> get props {
    return [id, amount, source, createAt, type];
  }

  TransactionModel copyWith({
    String? id,
    double? amount,
    String? source,
    DateTime? createAt,
    String? type,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      source: source ?? this.source,
      createAt: createAt ?? this.createAt,
      type: type ?? this.type,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'source': source,
      'createAt': createAt.millisecondsSinceEpoch,
      'type': type,
    };
  }

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'] ?? '',
      amount: map['amount']?.toDouble() ?? 0.0,
      source: map['source'] ?? '',
      createAt: DateTime.fromMillisecondsSinceEpoch(map['createAt']),
      type: map['type'] ?? '',
    );
  }

  @override
  String toString() {
    return 'TransactionModel(id: $id, amount: $amount, source: $source, createAt: $createAt, type: $type)';
  }
}
