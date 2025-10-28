import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/budget.dart';
import '../services/storage_service.dart';
import 'transaction_provider.dart';

final budgetsProvider = FutureProvider<List<Budget>>((ref) async {
  final storageService = ref.read(storageServiceProvider);
  return storageService.getAllBudgets();
});

final budgetsByMonthProvider = FutureProvider.family<List<Budget>, DateTime>((
  ref,
  date,
) async {
  final storageService = ref.read(storageServiceProvider);
  try {
    final budgets = await storageService.getBudgetsForMonth(
      date.month,
      date.year,
    );
    return budgets;
  } catch (e) {
    return <Budget>[]; // Return empty list on error
  }
});

final budgetStatusProvider =
    FutureProvider.family<Map<String, double>, DateTime>((ref, date) async {
      final storageService = ref.read(storageServiceProvider);
      return storageService.getBudgetStatus(date.month, date.year);
    });

final budgetByCategoryProvider = FutureProvider.family<Budget?, BudgetQuery>((
  ref,
  query,
) async {
  final storageService = ref.read(storageServiceProvider);
  return storageService.getBudgetByCategory(
    query.category,
    query.month,
    query.year,
  );
});

class BudgetQuery {
  final String category;
  final int month;
  final int year;

  BudgetQuery({
    required this.category,
    required this.month,
    required this.year,
  });
}

class BudgetNotifier extends StateNotifier<AsyncValue<void>> {
  final StorageService _storageService;
  final Ref _ref;

  BudgetNotifier(this._storageService, this._ref)
    : super(const AsyncValue.data(null));

  Future<void> addBudget(Budget budget) async {
    state = const AsyncValue.loading();
    try {
      await _storageService.addBudget(budget);
      state = const AsyncValue.data(null);
      _invalidateProviders();
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> updateBudget(Budget budget) async {
    state = const AsyncValue.loading();
    try {
      await _storageService.updateBudget(budget);
      state = const AsyncValue.data(null);
      _invalidateProviders();
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> deleteBudget(String id) async {
    state = const AsyncValue.loading();
    try {
      await _storageService.deleteBudget(id);
      state = const AsyncValue.data(null);
      _invalidateProviders();
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  void _invalidateProviders() {
    _ref.invalidate(budgetsProvider);
    _ref.invalidate(budgetsByMonthProvider(DateTime.now()));
    _ref.invalidate(budgetStatusProvider(DateTime.now()));
    _ref.invalidate(expenseByCategoryProvider(DateTime.now()));
  }
}

final budgetNotifierProvider =
    StateNotifierProvider<BudgetNotifier, AsyncValue<void>>((ref) {
      final storageService = ref.watch(storageServiceProvider);
      return BudgetNotifier(storageService, ref);
    });
