import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/transaction.dart';
import '../services/storage_service.dart';

final storageServiceProvider = Provider<StorageService>((ref) {
  return StorageService();
});

final transactionsProvider = FutureProvider<List<Transaction>>((ref) async {
  final storageService = ref.read(storageServiceProvider);
  return storageService.getAllTransactions();
});

final recentTransactionsProvider = FutureProvider<List<Transaction>>((
  ref,
) async {
  final storageService = ref.read(storageServiceProvider);
  return storageService.getRecentTransactions(limit: 10);
});

final transactionsByTypeProvider =
    FutureProvider.family<List<Transaction>, String>((ref, type) async {
      final storageService = ref.read(storageServiceProvider);
      return storageService.getTransactionsByType(type);
    });

final totalIncomeProvider = FutureProvider<double>((ref) async {
  final storageService = ref.read(storageServiceProvider);
  return storageService.getTotalIncome();
});

final totalExpensesProvider = FutureProvider<double>((ref) async {
  final storageService = ref.read(storageServiceProvider);
  return storageService.getTotalExpenses();
});

final balanceProvider = FutureProvider<double>((ref) async {
  final storageService = ref.read(storageServiceProvider);
  return storageService.getBalance();
});

final expenseByCategoryProvider =
    FutureProvider.family<Map<String, double>, DateTime>((ref, date) async {
      final storageService = ref.read(storageServiceProvider);
      return storageService.getSpendingByCategory(date.month, date.year);
    });

class TransactionNotifier extends StateNotifier<AsyncValue<void>> {
  final StorageService _storageService;
  final Ref _ref;

  TransactionNotifier(this._storageService, this._ref)
    : super(const AsyncValue.data(null));

  Future<void> addTransaction(Transaction transaction) async {
    state = const AsyncValue.loading();
    try {
      await _storageService.addTransaction(transaction);
      state = const AsyncValue.data(null);
      _invalidateProviders();
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> updateTransaction(Transaction transaction) async {
    state = const AsyncValue.loading();
    try {
      await _storageService.updateTransaction(transaction);
      state = const AsyncValue.data(null);
      _invalidateProviders();
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> deleteTransaction(String id) async {
    state = const AsyncValue.loading();
    try {
      await _storageService.deleteTransaction(id);
      state = const AsyncValue.data(null);
      _invalidateProviders();
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  void _invalidateProviders() {
    _ref.invalidate(transactionsProvider);
    _ref.invalidate(recentTransactionsProvider);
    _ref.invalidate(totalIncomeProvider);
    _ref.invalidate(totalExpensesProvider);
    _ref.invalidate(balanceProvider);
    _ref.invalidate(expenseByCategoryProvider(DateTime.now()));
  }
}

final transactionNotifierProvider =
    StateNotifierProvider<TransactionNotifier, AsyncValue<void>>((ref) {
      final storageService = ref.watch(storageServiceProvider);
      return TransactionNotifier(storageService, ref);
    });
