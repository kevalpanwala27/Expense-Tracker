import 'package:flutter_test/flutter_test.dart';
import 'package:expense_tracker/models/budget.dart';

void main() {
  group('Budget Model Tests', () {
    test('Budget creation', () {
      final budget = Budget(
        id: '1',
        category: 'Food',
        limit: 5000,
        month: 1,
        year: 2024,
      );

      expect(budget.id, '1');
      expect(budget.category, 'Food');
      expect(budget.limit, 5000);
      expect(budget.month, 1);
      expect(budget.year, 2024);
    });

    test('Budget copyWith', () {
      final original = Budget(
        id: '1',
        category: 'Food',
        limit: 5000,
        month: 1,
        year: 2024,
      );

      final copied = original.copyWith(category: 'Travel', limit: 6000);

      expect(copied.category, 'Travel');
      expect(copied.limit, 6000);
      expect(copied.id, original.id);
      expect(copied.month, original.month);
    });

    test('Budget toJson and fromJson', () {
      final budget = Budget(
        id: '1',
        category: 'Food',
        limit: 5000,
        month: 1,
        year: 2024,
      );

      final json = budget.toJson();
      expect(json['id'], '1');
      expect(json['category'], 'Food');
      expect(json['limit'], 5000);

      final fromJson = Budget.fromJson(json);
      expect(fromJson.id, budget.id);
      expect(fromJson.category, budget.category);
      expect(fromJson.limit, budget.limit);
    });
  });
}
