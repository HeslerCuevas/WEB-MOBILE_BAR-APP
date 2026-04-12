import 'package:drift/drift.dart';

/// Tabla: Caché offline de categorías del menú
class CategoriasCache extends Table {
  IntColumn get id => integer()();
  TextColumn get nombre => text()();
  TextColumn get descripcion => text().nullable()();
  TextColumn get urlImagenIcono => text().nullable()();
  DateTimeColumn get sincronizadoEn => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
