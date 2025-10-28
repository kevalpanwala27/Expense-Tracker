import 'package:flutter_test/flutter_test.dart';
import 'package:expense_tracker/models/transaction.dart';
import 'package:expense_tracker/models/budget.dart';

void main() {
  group('Transaction Model Unit Tests', () {
    test('Transaction creation', () {
      final transaction = Transaction(
        id: 'test_1',
        title: 'Test Expense',
        amount: 1000,
        category: 'Food & Dining',
        date: DateTime.now(),
        type: 'expense',
        notes: 'Test notes',
      );

      expect(transaction.title, 'Test Expense');
      expect(transaction.amount, 1000);
      expect(transaction.type, 'expense');
    });

    test('Transaction toJson and fromJson', () {
      final transaction = Transaction(
        id: '1',
        title: 'Test',
        amount: 100,
        category: 'Food',
        date: DateTime(2024, 1, 1),
        type: 'expense',
        notes: 'Notes',
      );

      final json = transaction.toJson();
      expect(json['id'], '1');
      expect(json['title'], 'Test');
      expect(json['amount'], 100);

      final fromJson = Transaction.fromJson(json);
      expect(fromJson.id, transaction.id);
      expect(fromJson.title, transaction.title);
      expect(fromJson.amount, transaction.amount);
    });
  });

  group('Budget Model Unit Tests', () {
    test('Budget creation', () {
      final budget = Budget(
        id: '1',
        category: 'Food',
        limit: 5000,
        month: 1,
        year: 2024,
      );

      expect(budget.category, 'Food');
      expect(budget.limit, 5000);
      expect(budget.month, 1);
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
