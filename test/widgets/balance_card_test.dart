import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:expense_tracker/widgets/balance_card.dart';

void main() {
  testWidgets('BalanceCard displays loading state', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: Scaffold(body: BalanceCard())),
      ),
    );

    // Should show a loading indicator initially
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
