import 'package:flutter_test/flutter_test.dart';
import 'package:bar_lounge_app/data/database/app_database.dart';

void main() {
  testWidgets('Wipe all SQLite data', (tester) async {
    final db = AppDatabase();
    await db.clearAllTables();
    await db.close();
    print('DATABASE SUCCESSFULLY WIPED: ALL ROWS DELETED.');
  });
}
