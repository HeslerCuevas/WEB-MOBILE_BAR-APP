import 'package:drift/drift.dart';

class PromocionesCache extends Table {
  IntColumn get id => integer()();
  TextColumn get nombre => text().withLength(max: 150)();
  TextColumn get descripcion => text().nullable().withLength(max: 500)();
  TextColumn get tipoDescuento => text().withLength(max: 20)();
  RealColumn get valor => real()();
  DateTimeColumn get fechaInicio => dateTime()();
  DateTimeColumn get fechaFin => dateTime().nullable()();
  BoolColumn get activo => boolean().withDefault(const Constant(true))();
  IntColumn get prioridad => integer().withDefault(const Constant(0))();
  TextColumn get aplicaA => text().withLength(max: 20).withDefault(const Constant('TODOS'))();
  BoolColumn get aplicaHappyHour => boolean().withDefault(const Constant(false))();
  TextColumn get horaInicioHh => text().nullable().withLength(max: 5)();
  TextColumn get horaFinHh => text().nullable().withLength(max: 5)();
  // Minimum final price floor — discount will never bring a product below this value
  RealColumn get precioMinimoFinal => real().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class PromocionesProductosCache extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get promocionId => integer()();
  IntColumn get productoId => integer()();
}

class PromocionesCategoriasCache extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get promocionId => integer()();
  IntColumn get categoriaId => integer()();
}
