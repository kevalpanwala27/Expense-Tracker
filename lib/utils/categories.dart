class Categories {
  static const List<String> expenseCategories = [
    'Food & Dining',
    'Shopping',
    'Transportation',
    'Bills & Utilities',
    'Entertainment',
    'Healthcare',
    'Education',
    'Travel',
    'Gifts & Donations',
    'Other',
  ];

  static const List<String> incomeCategories = [
    'Salary',
    'Freelance',
    'Investment',
    'Business',
    'Gift',
    'Other',
  ];

  static const Map<String, String> categoryIcons = {
    'Food & Dining': '🍽️',
    'Shopping': '🛍️',
    'Transportation': '🚗',
    'Bills & Utilities': '💡',
    'Entertainment': '🎬',
    'Healthcare': '🏥',
    'Education': '📚',
    'Travel': '✈️',
    'Gifts & Donations': '🎁',
    'Other': '📦',
    'Salary': '💰',
    'Freelance': '💼',
    'Investment': '📈',
    'Business': '🏢',
    'Gift': '🎁',
  };

  static const Map<String, List<int>> categoryColors = {
    'Food & Dining': [0xFF, 0xEF, 0x53, 0x50], // Red
    'Shopping': [0xFF, 0x9C, 0x27, 0xB0], // Purple
    'Transportation': [0xFF, 0x21, 0x96, 0xF3], // Blue
    'Bills & Utilities': [0xFF, 0xFF, 0x98, 0x00], // Orange
    'Entertainment': [0xFF, 0xE9, 0x1E, 0x63], // Pink
    'Healthcare': [0xFF, 0x4C, 0xAF, 0x50], // Green
    'Education': [0xFF, 0x00, 0x96, 0x88], // Teal
    'Travel': [0xFF, 0x00, 0xBC, 0xD4], // Cyan
    'Gifts & Donations': [0xFF, 0xFF, 0x57, 0x22], // Amber
    'Other': [0xFF, 0x9E, 0x9E, 0x9E], // Grey
    'Salary': [0xFF, 0x4C, 0xAF, 0x50], // Green
    'Freelance': [0xFF, 0x21, 0x96, 0xF3], // Blue
    'Investment': [0xFF, 0xFF, 0x98, 0x00], // Orange
    'Business': [0xFF, 0x9C, 0x27, 0xB0], // Purple
    'Gift': [0xFF, 0xFF, 0x57, 0x22], // Amber
  };

  static String getIcon(String category) {
    return categoryIcons[category] ?? '📦';
  }

  static List<int> getColor(String category) {
    return categoryColors[category] ?? [0xFF, 0x9E, 0x9E, 0x9E];
  }
}
