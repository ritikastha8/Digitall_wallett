class HiveTableConstant {
  // private constructor to prevent instantiation
  HiveTableConstant._();

  // Database name
  static const String dbName = 'digital_wallet_db';

  // Table/Box names and type IDs
  static const int authTypeId = 0;
  static const String authTable = 'auth_table'; // login/signup info

  static const int userTypeId = 1;
  static const String userTable = 'user_table'; // user profile info

  static const int transactionTypeId = 3;
  static const String transactionTable =
      'transaction_table'; // all transactions

  static const int settingsTypeId = 4;
  static const String settingsTable =
      'settings_table'; // app preferences/settings

  static const int categoryTypeId = 5;
  static const String categoryTable =
      'category_table'; // transaction categories
}
