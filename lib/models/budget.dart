import 'package:hive/hive.dart';

part 'budget.g.dart';

@HiveType(typeId: 1)
class Budget extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String category;

  @HiveField(2)
  final double limit;

  @HiveField(3)
  final int month;

  @HiveField(4)
  final int year;

  Budget({
    required this.id,
    required this.category,
    required this.limit,
    required this.month,
    required this.year,
  });

  Budget copyWith({
    String? id,
    String? category,
    double? limit,
    int? month,
    int? year,
  }) {
    return Budget(
      id: id ?? this.id,
      category: category ?? this.category,
      limit: limit ?? this.limit,
      month: month ?? this.month,
      year: year ?? this.year,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category': category,
      'limit': limit,
      'month': month,
      'year': year,
    };
  }

  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
      id: json['id'],
      category: json['category'],
      limit: (json['limit'] as num).toDouble(),
      month: json['month'],
      year: json['year'],
    );
  }
}
