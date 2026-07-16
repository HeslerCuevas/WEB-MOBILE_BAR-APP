import 'package:drift/drift.dart';
import 'categorias_cache.dart';
class ProductosCache extends Table {
  IntColumn get id => integer()();
  TextColumn get sku => text().nullable()();
  TextColumn get nombre => text()();
  TextColumn get descripcion => text().nullable()();
  RealColumn get precioBase => real()();
  RealColumn get tasaImpuesto => real().withDefault(const Constant(0.18))();
  BoolColumn get estaDisponible => boolean().withDefault(const Constant(true))();
  TextColumn get imagenUrl => text().nullable()();
  IntColumn get cantidadDisponible => integer().nullable()();
  IntColumn get categoriaId => integer().references(CategoriasCache, #id)();
  DateTimeColumn get sincronizadoEn => dateTime().withDefault(currentDateAndTime)();
  @override
  Set<Column> get primaryKey => {id};
}
