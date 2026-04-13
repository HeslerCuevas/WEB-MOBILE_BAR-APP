import 'package:flutter_test/flutter_test.dart';
import 'package:bar_lounge_app/data/database/app_database.dart';
import 'package:drift/native.dart'; // Asegúrate de tener drift y sqlite3_flutter_libs

import 'package:flutter/services.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const MethodChannel channel = MethodChannel('plugins.flutter.io/path_provider');
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, (MethodCall methodCall) async {
    return '.';
  });
  
  // 1. Usamos 'test' en lugar de 'testWidgets'
  test('Wipe all SQLite data', () async {
    // 2. Recomendado: Usar una instancia en memoria para tests si es posible
    // Si necesitas wipear el archivo real, asegúrate de que no haya otra instancia abierta.
    final db = AppDatabase(); 

    print('Iniciando limpieza...');
    final stopwatch = Stopwatch()..start();

    await db.clearAllTables();
    
    stopwatch.stop();
    print('DATABASE SUCCESSFULLY WIPED en ${stopwatch.elapsedMilliseconds}ms');

    await db.close();
  });
}