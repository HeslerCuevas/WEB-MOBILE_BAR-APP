import 'dart:io';
import 'package:flutter/material.dart';
import 'package:bar_lounge_app/data/database/app_database.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final db = AppDatabase();
  await db.clearAllTables();
  await db.close();
  print('========================================================');
  print('✅ SUCCESSFULLY WIPED ALL ROWS FROM ALL TABLES IN THE LOCAL DB');
  print('========================================================');
  exit(0);
}
