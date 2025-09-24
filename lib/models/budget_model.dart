import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'package:money_management_app/models/kategori_model.dart';

class BudgetModel {
  final String? id;
  final String name;
  final double amount;
  final DateTime startAt;
  final DateTime endAt;
  final String range; // Tambahan: 'monthly', 'weekly', 'yearly', dll
  final String? description;
  final DateTime createdAt;
  final String userId; // Tambahan: ID pengguna yang memiliki budget
  final List<KategoriModel>? kategoris;
  final Color? color; // Optional color field

  BudgetModel({
    DateTime? createdAt,
    this.id,
    required this.name,
    required this.amount,
    required this.startAt,
    required this.endAt,
    this.range = 'bulanan', // default bulanan
    this.description,
    required this.userId,
    this.kategoris,
    this.color,
  }) : createdAt = createdAt ?? DateTime.now();

  BudgetModel copyWith({
    ValueGetter<String?>? id,
    String? name,
    double? amount,
    DateTime? startAt,
    DateTime? endAt,
    String? range,
    ValueGetter<String?>? description,
    DateTime? createdAt,
    String? userId,
    ValueGetter<List<KategoriModel>?>? kategoris,
    ValueGetter<Color?>? color,
  }) {
    return BudgetModel(
      id: id != null ? id() : this.id,
      name: name ?? this.name,
      amount: amount ?? this.amount,
      startAt: startAt ?? this.startAt,
      endAt: endAt ?? this.endAt,
      range: range ?? this.range,
      description: description != null ? description() : this.description,
      createdAt: createdAt ?? this.createdAt,
      userId: userId ?? this.userId,
      kategoris: kategoris != null ? kategoris() : this.kategoris,
      color: color != null ? color() : this.color,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      // 'id': id,
      'name': name,
      'amount': amount,
      'startAt': startAt.millisecondsSinceEpoch,
      'endAt': endAt.millisecondsSinceEpoch,
      'range': range,
      'description': description,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'userId': userId,
      'kategoris': kategoris?.map((x) => x?.toMap())?.toList(),
      'color': color?.value,
    };
  }

  factory BudgetModel.fromMap(Map<String, dynamic> map) {
    return BudgetModel(
      id: map['id'],
      name: map['name'] ?? '',
      amount: map['amount']?.toDouble() ?? 0.0,
      startAt: DateTime.fromMillisecondsSinceEpoch(map['startAt']),
      endAt: DateTime.fromMillisecondsSinceEpoch(map['endAt']),
      range: map['range'] ?? '',
      description: map['description'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      userId: map['userId'] ?? '',
      kategoris: map['kategoris'] != null
          ? List<KategoriModel>.from(
              map['kategoris']?.map((x) => KategoriModel.fromMap(x)),
            )
          : null,
      color: map['color'] != null ? Color(map['color']) : null,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is BudgetModel &&
        other.id == id &&
        other.name == name &&
        other.amount == amount &&
        other.startAt == startAt &&
        other.endAt == endAt &&
        other.range == range &&
        other.description == description &&
        other.createdAt == createdAt &&
        other.userId == userId &&
        listEquals(other.kategoris, kategoris) &&
        other.color == color;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        amount.hashCode ^
        startAt.hashCode ^
        endAt.hashCode ^
        range.hashCode ^
        description.hashCode ^
        createdAt.hashCode ^
        userId.hashCode ^
        kategoris.hashCode ^
        color.hashCode;
  }
}
