// ignore_for_file: deprecated_member_use

import 'package:flutter/widgets.dart';

class KategoriModel {
  String? id;
  String userId; // User ID for the owner of the category
  String budgetId; // Budget ID this category belongs to
  String kategori;
  double planned;
  Color? color;
  DateTime? createdAt;

  KategoriModel({
    this.id,
    required this.userId,
    required this.budgetId,
    required String kategori,
    this.color = const Color(0xFF000000), // Default color if not provided
    required this.planned,
    DateTime? createdAt,
  }) : kategori = kategori.toUpperCase(),
       createdAt = createdAt ?? DateTime.now();

  KategoriModel copyWith({
    ValueGetter<String?>? id,
    String? userId,
    String? budgetId,
    String? kategori,
    double? planned,
    ValueGetter<Color?>? color,
    ValueGetter<DateTime?>? createdAt,
  }) {
    return KategoriModel(
      id: id != null ? id() : this.id,
      userId: userId ?? this.userId,
      budgetId: budgetId ?? this.budgetId,
      kategori: kategori ?? this.kategori,
      planned: planned ?? this.planned,
      color: color != null ? color() : this.color,
      createdAt: createdAt != null ? createdAt() : this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'budgetId': budgetId,
      'kategori': kategori.toUpperCase(),
      'planned': planned,
      'color': color?.value,
      'createdAt': createdAt?.millisecondsSinceEpoch,
    };
  }

  factory KategoriModel.fromMap(Map<String, dynamic> map) {
    return KategoriModel(
      id: map['id'],
      userId: map['userId'] ?? '',
      budgetId: map['budgetId'] ?? '',
      kategori: map['kategori'].toString().toUpperCase(),
      planned: map['planned']?.toDouble() ?? 0.0,
      color: map['color'] != null ? Color(map['color']) : null,
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'])
          : null,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is KategoriModel &&
        other.id == id &&
        other.userId == userId &&
        other.budgetId == budgetId &&
        other.kategori == kategori &&
        other.planned == planned &&
        other.color == color &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        budgetId.hashCode ^
        kategori.hashCode ^
        planned.hashCode ^
        color.hashCode ^
        createdAt.hashCode;
  }

  static KategoriModel clone(KategoriModel k) {
    return KategoriModel(
      id: k.id,
      userId: k.userId,
      budgetId: k.budgetId,
      kategori: k.kategori,
      planned: k.planned,
      color: k.color,
      createdAt: k.createdAt,
    );
  }
}
