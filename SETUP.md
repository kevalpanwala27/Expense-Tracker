# Expense Tracker - Setup Guide

## Quick Start

1. **Clone the repository**
   ```bash
   cd /path/to/expense_tracker
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## Running Tests

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Run specific test file
flutter test test/models/transaction_test.dart
```

## Building for Release

**Android APK:**
```bash
flutter build apk --release
```

**iOS:**
```bash
flutter build ios --release
```

**Web:**
```bash
flutter build web --release
```

## Project Structure

```
lib/
├── main.dart                          # App entry point & navigation
├── models/                            # Data models with Hive adapters
│   ├── transaction.dart
│   ├── budget.dart
│   └── categories.dart
├── services/                          # Data layer
│   └── storage_service.dart           # Hive storage implementation
├── providers/                         # Riverpod state management
│   ├── transaction_provider.dart
│   ├── budget_provider.dart
│   └── theme_provider.dart
├── screens/                           # UI screens
│   ├── dashboard_screen.dart
│   ├── transactions_screen.dart
│   ├── budgets_screen.dart
│   ├── add_transaction_screen.dart
│   └── add_budget_screen.dart
└── widgets/                           # Reusable widgets
    ├── balance_card.dart
    ├── expense_chart.dart
    └── recent_transactions_widget.dart

test/
├── models/                            # Model unit tests
│   ├── transaction_test.dart
│   └── budget_test.dart
├── services/                          # Service tests
│   └── storage_service_test.dart
└── widgets/                           # Widget tests
    └── balance_card_test.dart
```

## Key Features Implemented

✅ **Dashboard with balance, recent transactions, and charts**
✅ **Full CRUD operations for transactions**
✅ **Swipe-to-delete with confirmation**
✅ **Budget tracking with progress indicators**
✅ **Dark mode support**
✅ **Riverpod for state management**
✅ **Hive for offline storage**
✅ **Unit and widget tests**
✅ **Responsive UI with Material Design 3**

## Architecture Decisions

### State Management: Riverpod
- Type-safe state management
- Automatic resource disposal
- Excellent testing support
- Compile-time safety

### Storage: Hive
- Fast NoSQL database
- Type-safe with adapters
- Offline-first approach
- Simple API

### Charts: fl_chart
- Beautiful and customizable charts
- Good performance
- Rich animation support

## Development Notes

### Running Tests
The test suite includes:
- Model tests (Transaction, Budget)
- Service tests (Storage operations)
- Widget tests (UI components)

### Git Commits
The project has meaningful commits following conventional commits:
1. Initial setup with dependencies
2. Models and Hive setup
3. Storage service implementation
4. Riverpod providers
5. UI screens
6. Dark mode and animations
7. Tests

## Troubleshooting

### Build Issues
```bash
# Clean build
flutter clean
flutter pub get
flutter run
```

### Hive Errors
If you encounter Hive adapter errors, run:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Next Steps for Submission

1. Create Loom video walkthrough
2. Show git log with meaningful commits
3. Demo the app functionality
4. Explain architecture choices
5. Show test coverage

