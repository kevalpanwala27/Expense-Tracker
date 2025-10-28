import 'package:flutter_test/flutter_test.dart';
import 'package:expense_tracker/models/transaction.dart';

void main() {
  group('Transaction Model Tests', () {
    test('Transaction creation', () {
      final transaction = Transaction(
        id: '1',
        title: 'Test Transaction',
        amount: 100,
        category: 'Food',
        date: DateTime.now(),
        type: 'expense',
        notes: 'Test notes',
      );

      expect(transaction.id, '1');
      expect(transaction.title, 'Test Transaction');
      expect(transaction.amount, 100);
      expect(transaction.category, 'Food');
      expect(transaction.type, 'expense');
      expect(transaction.notes, 'Test notes');
    });

    test('Transaction copyWith', () {
      final original = Transaction(
        id: '1',
        title: 'Original',
        amount: 100,
        category: 'Food',
        date: DateTime.now(),
        type: 'expense',
      );

      final copied = original.copyWith(title: 'Updated', amount: 200);

      expect(copied.title, 'Updated');
      expect(copied.amount, 200);
      expect(copied.id, original.id);
      expect(copied.category, original.category);
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
}
