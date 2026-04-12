import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';
import 'data/database/app_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // ---> ONE-TIME DATABASE WIPE <---
  // Injected temporarily to delete all rows without schema drops.
  // REMOVE THESE 3 LINES AFTER HOT RESTARTING ONCE
  final db = AppDatabase();
  await db.clearAllTables();
  await db.close();
  
  runApp(
    const ProviderScope(
      child: NocturnalApp(),
    ),
  );
}
