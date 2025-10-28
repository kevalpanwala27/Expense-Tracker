# Expense Tracker App

A smart personal finance and expense tracker app built with Flutter. This app helps users track their income and expenses, set budgets, and visualize their spending patterns.

## Features

### Core Features ✅

- **Dashboard**
  - Current balance display (Income - Expenses)
  - Recent transactions (last 10)
  - Interactive expense charts by category
  - Real-time financial summaries

- **Transactions**
  - Add, edit, and delete transactions
  - Support for income and expense types
  - Multiple categories (Food, Travel, Bills, etc.)
  - Swipe-to-delete functionality with undo confirmation
  - Detailed transaction notes
  - Input validation and error handling

- **Budgets**
  - Set monthly budgets per category
  - Visual progress indicators
  - Over-budget alerts and warnings
  - Real-time budget tracking
  - Monthly budget management

### Bonus Features ⭐

- **Dark Mode**: Toggle between light and dark themes
- **Smooth Animations**: Fluid transitions and interactions
- **Swipe Gestures**: Swipe-to-delete with confirmation dialogs
- **Category Icons**: Visual category representations
- **Responsive UI**: Modern Material Design 3 interface

## Screenshots

![Dashboard](screenshots/dashboard.png)
![Transactions](screenshots/transactions.png)
![Budgets](screenshots/budgets.png)

## Getting Started

### Prerequisites

- Flutter 3.x or higher
- Dart 3.9 or higher
- Android Studio / Xcode (for mobile development)
- VS Code / Android Studio (for development)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd expense_tracker
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Build for Production

**Android:**
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

## Architecture

### Tech Stack

- **Flutter**: Cross-platform mobile framework
- **Riverpod**: State management solution
- **Hive**: Fast, lightweight local NoSQL database
- **fl_chart**: Beautiful charts and data visualization
- **Material Design 3**: Modern UI components

### Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── transaction.dart     # Transaction model
│   ├── budget.dart          # Budget model
│   └── categories.dart      # Category utilities
├── services/                # Business logic & data layer
│   └── storage_service.dart # Hive storage service
├── providers/               # Riverpod providers
│   ├── transaction_provider.dart
│   ├── budget_provider.dart
│   └── theme_provider.dart
├── screens/                 # UI screens
│   ├── dashboard_screen.dart
│   ├── transactions_screen.dart
│   ├── budgets_screen.dart
│   ├── add_transaction_screen.dart
│   └── add_budget_screen.dart
└── widgets/                 # Reusable widgets
    ├── balance_card.dart
    ├── recent_transactions_widget.dart
    └── expense_chart.dart
```

### State Management

This app uses **Riverpod** for state management, providing:

- **Type-safe state**: Compile-time safety for state management
- **Auto-disposal**: Automatic resource cleanup
- **Dependency injection**: Easy testing and modularity
- **Reactive updates**: Automatic UI updates on state changes

#### Key Providers:

- `transactionsProvider`: Stream of all transactions
- `recentTransactionsProvider`: Last 10 transactions
- `budgetsProvider`: All budgets
- `balanceProvider`: Current balance calculation
- `themeNotifierProvider`: Theme mode management

### Data Layer

**Hive Database** is used for local storage:

- **Type-safe storage**: Type adapters for models
- **Fast performance**: NoSQL key-value database
- **Offline-first**: All data stored locally
- **CRUD operations**: Full transaction management

### UI/UX Design

- **Material Design 3**: Modern, adaptive design system
- **Responsive layouts**: Works on all screen sizes
- **Accessibility**: Screen reader support
- **Color theming**: Custom color schemes
- **Smooth animations**: Delightful user experience

## Testing

### Running Tests

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Watch mode
flutter test --watch
```

### Test Coverage

- **Unit Tests**: Models, services, and utilities
- **Widget Tests**: UI components and interactions
- **Integration Tests**: End-to-end user flows

Test files are located in the `test/` directory:
- `test/models/`: Transaction and Budget model tests
- `test/services/`: Storage service tests
- `test/widgets/`: Widget component tests

## Git Commits

The project follows conventional commits with meaningful messages:

1. `feat: add project structure and dependencies`
2. `feat: implement data models with Hive adapters`
3. `feat: create storage service with CRUD operations`
4. `feat: implement Riverpod providers for state management`
5. `feat: build dashboard with balance and charts`
6. `feat: add transactions screen with swipe-to-delete`
7. `feat: implement budgets screen with progress tracking`
8. `feat: add dark mode and theme switching`
9. `test: add unit and widget tests`
10. `docs: update README with architecture details`

## Future Enhancements

- [ ] Export transactions to CSV
- [ ] Data backup and restore
- [ ] Multiple currency support
- [ ] Recurring transactions
- [ ] Analytics dashboard with trends
- [ ] Cloud sync
- [ ] Multi-user support

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new features
5. Submit a pull request

## License

This project is licensed under the MIT License.

## Contact

For questions or feedback, please open an issue or contact the project maintainer.
